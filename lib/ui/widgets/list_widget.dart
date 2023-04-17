import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../navigator.dart';
import '../player/player_controller.dart';
import 'image_widget.dart';

class ListWidget extends StatelessWidget {
  const ListWidget(
    this.items,
    this.title,
    this.isCompleteList, {
    super.key,
  });
  final List<dynamic> items;
  final String title;
  final bool isCompleteList;

  @override
  Widget build(BuildContext context) {
    if (title == "Videos" || title.contains("Songs")) {
      return isCompleteList
          ? Expanded(child: listViewSongVid(items, isCompleteList))
          : SizedBox(
              height: items.length * 75.0,
              child: listViewSongVid(items, isCompleteList),
            );
    } else if (title.contains("playlists")) {
      return listViewPlaylists(items);
    } else if (title == "Albums" || title == "Singles") {
      return listViewAlbums(items);
    } else if (title.contains('Artists')) {
      return listViewArtists(items);
    }
    return const SizedBox.shrink();
  }

  Widget listViewSongVid(List<dynamic> items, bool isCompleteList) {
    final playerController = Get.find<PlayerController>();
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: items.length,
        physics: isCompleteList
            ? const BouncingScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => ListTile(
              onTap: () {
                playerController.pushSongToQueue(items[index] as MediaItem);
              },
              contentPadding: const EdgeInsets.only(top: 0, left: 5, right: 30),
              leading: SizedBox.square(
                  dimension: 50,
                  child: ImageWidget(
                    song: items[index],
                  )),
              title: Text(
                items[index].title,
                maxLines: 1,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                "${items[index].artist}",
                maxLines: 1,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              trailing: Text(
                items[index].extras!['length'] ?? "",
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ));
  }

  Widget listViewPlaylists(List<dynamic> playlists) {
    return Expanded(
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: playlists.length,
          itemExtent: 100,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => ListTile(
                visualDensity: const VisualDensity(vertical: 4.0),
                isThreeLine: true,
                onTap: () {
                  Get.toNamed(ScreenNavigationSetup.playlistNAlbumScreen,
                      id: ScreenNavigationSetup.id,
                      arguments: [false, playlists[index]]);
                },
                contentPadding:
                    const EdgeInsets.only(top: 0, bottom: 0, left: 10),
                leading: SizedBox.square(
                    dimension: 100,
                    child: ImageWidget(
                      playlist: playlists[index],
                      isMediumImage: true,
                    )),
                title: Text(
                  playlists[index].title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  playlists[index].description,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              )),
    );
  }

  Widget listViewAlbums(List<dynamic> albums) {
    return Expanded(
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: albums.length,
        itemExtent: 100,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          String artistName = "";
          for (dynamic items in (albums[index].artists).sublist(1)) {
            artistName = "${artistName + items['name']},";
          }
          artistName =
              artistName.length > 16 ? artistName.substring(0, 16) : artistName;
          return ListTile(
            visualDensity: const VisualDensity(vertical: 4.0),
            isThreeLine: true,
            onTap: () {
              Get.toNamed(ScreenNavigationSetup.playlistNAlbumScreen,
                  id: ScreenNavigationSetup.id,
                  arguments: [true, albums[index]]);
            },
            contentPadding: const EdgeInsets.only(top: 0, bottom: 0, left: 10),
            leading: SizedBox.square(
                dimension: 100,
                child: ImageWidget(
                  album: albums[index],
                  isMediumImage: true,
                )),
            title: Text(
              albums[index].title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              "$artistName\n${(albums[index].artists[0]['name'])} • ${albums[index].year}",
              maxLines: 2,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          );
        },
      ),
    );
  }

  Widget listViewArtists(List<dynamic> artists) {
    return Expanded(
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: artists.length,
          itemExtent: 90,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => ListTile(
                visualDensity: const VisualDensity(horizontal: -2, vertical: 2),
                onTap: () {
                  Get.toNamed(ScreenNavigationSetup.artistScreen,
                      id: ScreenNavigationSetup.id, arguments: artists[index]);
                },
                contentPadding:
                    const EdgeInsets.only(top: 0, bottom: 0, left: 5),
                leading: Container(
                    height: 90,
                    width: 90,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: ImageWidget(
                      artist: artists[index],
                      isMediumImage: true,
                    )),
                title: Text(
                  artists[index].name,
                  maxLines: 1,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  artists[index].subscribers,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              )),
    );
  }
}