import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_kit/media_kit.dart' as media_kit;
import 'package:media_kit_video/media_kit_video.dart' as media_kit_video;
import 'package:wirc_2025/src/app/pages/main_page/cubit/video_files_cubit.dart';
import 'package:wirc_2025/src/data/data.dart' as data;

class VideosWidget extends StatefulWidget {
  const VideosWidget({
    super.key,
  });

  @override
  State<VideosWidget> createState() => _VideosWidgetState();
}

class _VideosWidgetState extends State<VideosWidget> {
  // String? selectedDirectory;
  // String? selectedFile;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<VideoFilesCubit>(context).updateVideoFiles(isDirty: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return narrowScreen(context);
      } else {
        return wideScreen(context);
      }
    });
  }

  Widget narrowScreen(context) {
    return Column(
      children: [
        ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
          child: videoPane(context),
        ),
        Expanded(
          child: Column(
            children: [
              selectPane(context),
              Expanded(
                child: contentPane(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget wideScreen(context) {
    return Row(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
            child: videoPane(context),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              selectPane(context),
              Expanded(
                child: contentPane(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget videoPane(context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: VideoScreen(),
    );
  }

  Widget selectPane(context) {
    return Wrap(
      spacing: 10.0,
      // runSpacing: 20.0,
      children: [
        directoryListBuilder(),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: ElevatedButton(
            child: Text('Update'),
            onPressed: () {
              BlocProvider.of<VideoFilesCubit>(context)
                  .updateVideoFiles(isDirty: true);
            },
          ),
        ),
      ],
    );
  }

  Widget contentPane(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: fileListBuilder(),
    );
  }

  BlocConsumer<VideoFilesCubit, VideoFilesState> directoryListBuilder() {
    return BlocConsumer<VideoFilesCubit, VideoFilesState>(
      listenWhen: (previous, current) {
        return false;
      },
      listener: (context, state) {},
      buildWhen: (previous, current) {
        if (current.videoFilesResult.status == VideoFilesStatus.success) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        print(
            'Video directoryListBuilder: ${state.videoFilesResult.status.name}');
        if (state.videoFilesResult.status == VideoFilesStatus.success) {
          var directoryList = data.videoDirNames;

          return DropdownButton<String>(
            value: state.videoFilesResult.selectedDirectory,
            onChanged: (String? value) {
              setState(() {
                // selectedDirectory = value;
                BlocProvider.of<VideoFilesCubit>(context)
                    .updateVideoFiles(directoryName: value);
              });
            },
            items: directoryList
                .map<DropdownMenuItem<String>>((String directoryName) {
              return DropdownMenuItem<String>(
                value: directoryName,
                child: Text(directoryName),
              );
            }).toList(),
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

  BlocConsumer<VideoFilesCubit, VideoFilesState> fileListBuilder() {
    return BlocConsumer<VideoFilesCubit, VideoFilesState>(
      listenWhen: (previous, current) {
        return false;
      },
      listener: (context, state) {},
      buildWhen: (previous, current) {
        if (current.videoFilesResult.status == VideoFilesStatus.success) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        print('Video fileListBuilder: ${state.videoFilesResult.status.name}');
        if (state.videoFilesResult.status == VideoFilesStatus.success) {
          var fileList = data.videoFileNames;
          return ListView.builder(
            itemCount: fileList.length,
            itemBuilder: (context, index) => Container(
              child: ListTile(
                // selected:
                //   state.videoFilesResult.selectedFile == fileList[index],
                title: Text(
                  fileList[index],
                  style: state.videoFilesResult.selectedFile == fileList[index]
                      ? TextStyle(fontWeight: FontWeight.bold)
                      : TextStyle(fontWeight: FontWeight.normal),
                ),
                trailing: Wrap(
                  spacing: 10.0,
                  children: [
                    Icon(Icons.download),
                    Icon(Icons.delete),
                    Text(
                      '${index + 1} (${fileList.length})',
                    ),
                  ],
                ),
                onTap: () async {
                  BlocProvider.of<VideoFilesCubit>(context)
                      .updateVideoFiles(fileName: fileList[index]);
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

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => VideoScreenState();
}

class VideoScreenState extends State<VideoScreen> {
  late final player = media_kit.Player();
  late final controller = media_kit_video.VideoController(player);

  @override
  void initState() {
    print('Video initState.');
    super.initState();
    player.setRate(0.5);
  }

  @override
  void dispose() {
    print('Video dispose.');
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocListener<VideoFilesCubit, VideoFilesState>(
        listenWhen: (previous, current) {
          if (current.videoFilesResult.status == VideoFilesStatus.success) {
            return true;
          }
          return false;
        },
        listener: (context, state) {
          var mediaUri = state.videoFilesResult.videoUri;
          // MyScreenState.newVideo(mediaUri);
          openNewVideo(mediaUri);
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.width * 9.0 / 16.0,
          height: MediaQuery.of(context).size.width * 2.0 / 3.0,
          // Use [Video] widget to display video output.
          child: media_kit_video.Video(controller: controller),
        ),
      ),
    );
  }

  void openNewVideo(String videoUri) {
    player.open(media_kit.Media(videoUri));
  }

  void setVideoRate(Float videoRate) {
    player.setRate(0.5);
  }
}
