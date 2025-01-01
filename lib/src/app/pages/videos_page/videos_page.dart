import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart' as media_kit;
import 'package:media_kit_video/media_kit_video.dart' as media_kit_video;
import 'package:wirc_2025/src/app/pages/main_page/cubit/video_dirs_cubit.dart';
import 'package:wirc_2025/src/app/pages/main_page/cubit/video_files_cubit.dart';
// import 'package:wirc_2025/src/data/data.dart' as data;
import 'package:wirc_2025/src/core/core.dart' as core;

class VideosWidget extends StatefulWidget {
  const VideosWidget({
    super.key,
  });

  @override
  State<VideosWidget> createState() => _VideosWidgetState();
}

class _VideosWidgetState extends State<VideosWidget> {
  var isRunning = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // showVideo(),
          MyScreen(),

          Wrap(
            children: [
              Expanded(
                child: directoryListBuilder(),
              ),
              ElevatedButton(
                child: Text('Update'),
                onPressed: () {
                  BlocProvider.of<VideoDirsCubit>(context).fetchVideoDirs();
                },
              ),
            ],
          ),
          Expanded(
            child: fileListBuilder(),
          ),
        ],
      ),
    );
  }

  BlocConsumer<VideoDirsCubit, VideoDirsState> directoryListBuilder() {
    return BlocConsumer<VideoDirsCubit, VideoDirsState>(
      listenWhen: (previous, current) {
        return true;
      },
      listener: (context, state) {
        // if (state.videoDirsResult.status ==
        //     VideoDirsStatus.initial) {
        //   context
        //       .read<VideoDirsCubit>()
        //       .filterCountryByString(filterString ?? '');
        // }
      },
      buildWhen: (previous, current) {
        return true;
      },
      builder: (context, state) {
        if (state.videoDirsResult.status == VideoDirsStatus.success) {
          var directoryList = state.videoDirsResult.availableVideoDirs;

          return DropdownButton<String>(
            value: BlocProvider.of<VideoDirsCubit>(context)
                .getLastUsedSelectedVideoDir(),
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                BlocProvider.of<VideoDirsCubit>(context)
                    .setLastUsedSelectedVideoDir(value!);
                // dropdownValue = value!;
                BlocProvider.of<VideoFilesCubit>(context)
                    .fetchVideoFiles(value);
              });
            },
            items: directoryList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );
        } else if (state.videoDirsResult.status == VideoDirsStatus.initial) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state.videoDirsResult.status == VideoDirsStatus.loading) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state.videoDirsResult.status == VideoDirsStatus.failure) {
          return Center(child: Text(state.videoDirsResult.message));
        } else {
          return const Placeholder();
        }
      },
    );
  }

  BlocConsumer<VideoFilesCubit, VideoFilesState> fileListBuilder() {
    return BlocConsumer<VideoFilesCubit, VideoFilesState>(
      listenWhen: (previous, current) {
        return true;
      },
      listener: (context, state) {
        // if (state.videoDirsResult.status ==
        //     FilesStatus.initial) {
        //   context
        //       .read<FilesCubit>()
        //       .filterCountryByString(filterString ?? '');
        // }
      },
      buildWhen: (previous, current) {
        if (current.videoFilesResult.status ==
            VideoFilesStatus.selectedVideoChanged) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        if (state.videoFilesResult.status == VideoFilesStatus.success) {
          var fileList = state.videoFilesResult.availableVideoFiles;
          return ListView.builder(
            itemCount: fileList.length,
            itemBuilder: (context, index) => Card(
              child: ListTile(
                title: Text(fileList[index]),
                // trailing: Text(fileList[index].countryCode),
                trailing: Text(
                  '${index + 1} (${fileList.length})',
                  // '${fileList[index]}\n${index + 1} (${fileList.length})',
                ),
                onTap: () async {
                  BlocProvider.of<VideoFilesCubit>(context)
                      .setLastUsedSelectedFile(fileList[index]);

                  var mediaUri = core.getFileDownloadUri(fileList[index]);
                  MyScreenState.newVideo(mediaUri);

                  // await showDialog(
                  //     context: context, builder: (_) => VideoDialog());
                },
              ),
            ),
          );
        } else if (state.videoFilesResult.status == VideoFilesStatus.initial) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state.videoFilesResult.status == VideoFilesStatus.loading) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state.videoFilesResult.status == VideoFilesStatus.failure) {
          return Center(child: Text(state.videoFilesResult.message));
        } else {
          return const Placeholder();
        }
      },
    );
  }
}

class MyScreen extends StatefulWidget {
  const MyScreen({Key? key}) : super(key: key);
  @override
  State<MyScreen> createState() => MyScreenState();
}

class MyScreenState extends State<MyScreen> {
  // Create a [Player] to control playback.
  static final player = media_kit.Player();
  // late final player = media_kit.Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = media_kit_video.VideoController(player);

  static newVideo(mediaUri) {
    // player.open(media_kit.Media('http://wurb-aa-51c:8082/files/download?file_path=/home/wurb/wirc_recordings/wirc_2024-12-28/video_20241228T114248.mp4'));
    player.open(media_kit.Media(mediaUri));
  }

  @override
  void initState() {
    super.initState();
    // Play a [Media] or [Playlist].
    player.open(media_kit.Media(
        'https://user-images.githubusercontent.com/28951144/229373695-22f88f13-d18f-4288-9bf1-c3e078d83722.mp4'));
    // player.open(media_kit.Media('http://wurb-aa-51c:8082/files/download?file_path=/home/wurb/wirc_recordings/wirc_2024-12-28/video_20241228T114248.mp4'));
    player.setRate(0.5);
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.width * 9.0 / 16.0,
        height: MediaQuery.of(context).size.width * 2.0 / 3.0,
        // Use [Video] widget to display video output.
        child: media_kit_video.Video(controller: controller),
      ),
    );
  }

  void openNewVideo(String videoUri) {
    player.open(media_kit.Media(videoUri));
    // player.open(media_kit.Media('http://wurb-aa-51c:8082/files/download?file_path=/home/wurb/wirc_recordings/wirc_2024-12-28/video_20241228T114248.mp4'));
  }
}
