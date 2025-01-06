import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wirc_2025/src/app/pages/main_page/cubit/image_files_cubit.dart';
import 'package:wirc_2025/src/data/data.dart' as data;

class ImagesWidget extends StatefulWidget {
  const ImagesWidget({
    super.key,
  });

  @override
  State<ImagesWidget> createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends State<ImagesWidget> {
  // String? selectedDirectory;
  // String? selectedFile;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ImageFilesCubit>(context).updateImageFiles(isDirty: true);
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   BlocProvider.of<ImageFilesCubit>(context).updateImageFiles(isDirty: true);
    // });
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
          child: imagePane(context),
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
            child: imagePane(context),
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

  Widget imagePane(context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: showImage(),
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
              BlocProvider.of<ImageFilesCubit>(context)
                  .updateImageFiles(isDirty: true);
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

  BlocConsumer<ImageFilesCubit, ImageFilesState> showImage() {
    return BlocConsumer<ImageFilesCubit, ImageFilesState>(
      listenWhen: (previous, current) {
        return false;
      },
      listener: (context, state) {},
      buildWhen: (previous, current) {
        if (current.imageFilesResult.status == ImageFilesStatus.success) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        print('Image showImage: ${state.imageFilesResult.status.name}');
        if (state.imageFilesResult.status == ImageFilesStatus.success) {
          var imageUri = state.imageFilesResult.imageUri;
          if (imageUri == '') {
            return const Placeholder();
          }
          return Image.network(imageUri);
        } else {
          return const Placeholder();
        }
      },
    );
  }

  BlocConsumer<ImageFilesCubit, ImageFilesState> directoryListBuilder() {
    return BlocConsumer<ImageFilesCubit, ImageFilesState>(
      listenWhen: (previous, current) {
        return false;
      },
      listener: (context, state) {},
      buildWhen: (previous, current) {
        if (current.imageFilesResult.status == ImageFilesStatus.success) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        print('Image directoryListBuilder: ${state.imageFilesResult.status.name}');
        if (state.imageFilesResult.status == ImageFilesStatus.success) {
          var directoryList = data.imageDirNames;

          return DropdownButton<String>(
            value: state.imageFilesResult.selectedDirectory,
            onChanged: (String? value) {
              setState(() {
                // selectedDirectory = value;
                BlocProvider.of<ImageFilesCubit>(context)
                    .updateImageFiles(directoryName: value);
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
        } else if (state.imageFilesResult.status == ImageFilesStatus.initial) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state.imageFilesResult.status == ImageFilesStatus.loading) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state.imageFilesResult.status == ImageFilesStatus.failure) {
          return Center(child: Text(state.imageFilesResult.message));
        } else {
          return const Placeholder();
        }
      },
    );
  }

  BlocConsumer<ImageFilesCubit, ImageFilesState> fileListBuilder() {
    return BlocConsumer<ImageFilesCubit, ImageFilesState>(
      listenWhen: (previous, current) {
        return false;
      },
      listener: (context, state) {},
      buildWhen: (previous, current) {
        if (current.imageFilesResult.status == ImageFilesStatus.success) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        print('Image fileListBuilder: ${state.imageFilesResult.status.name}');
        if (state.imageFilesResult.status == ImageFilesStatus.success) {
          var fileList = data.imageFileNames;
          return ListView.builder(
            itemCount: fileList.length,
            itemBuilder: (context, index) => Container(
              child: ListTile(
                // selected:
                //   state.imageFilesResult.selectedFile == fileList[index],
                title: Text(
                  fileList[index],
                  style: state.imageFilesResult.selectedFile == fileList[index]
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
                  BlocProvider.of<ImageFilesCubit>(context)
                      .updateImageFiles(fileName: fileList[index]);
                },
              ),
            ),
          );
        } else if (state.imageFilesResult.status == ImageFilesStatus.initial) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state.imageFilesResult.status == ImageFilesStatus.loading) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state.imageFilesResult.status == ImageFilesStatus.failure) {
          return Center(child: Text(state.imageFilesResult.message));
        } else {
          return const Placeholder();
        }
      },
    );
  }
}
