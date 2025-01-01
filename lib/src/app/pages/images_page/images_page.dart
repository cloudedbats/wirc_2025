import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wirc_2025/src/app/pages/main_page/cubit/image_dirs_cubit.dart';
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
  var isRunning = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          showImage(),
          Wrap(
            children: [
              Expanded(
                child: directoryListBuilder(),
              ),
              ElevatedButton(
                child: Text('Update'),
                onPressed: () {
                  BlocProvider.of<ImageDirsCubit>(context).fetchImageDirs();
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

  // Image showImage() {
  //   return Image.network(
  //       'http://wurb-aa-51c:8082/files/download?file_path=/home/wurb/wirc_recordings/wirc_2024-12-28/image_20241228T135250.jpg');
  // }
  BlocConsumer<ImageFilesCubit, ImageFilesState> showImage() {
    return BlocConsumer<ImageFilesCubit, ImageFilesState>(
      listenWhen: (previous, current) {
        return true;
      },
      listener: (context, state) {
        // if (state.imageDirsResult.status ==
        //     FilesStatus.initial) {
        //   context
        //       .read<FilesCubit>()
        //       .filterCountryByString(filterString ?? '');
        // }
      },
      buildWhen: (previous, current) {
        return true;
      },
      builder: (context, state) {
        if (state.imageFilesResult.status ==
            ImageFilesStatus.selectedImageChanged) {
          var selectedFile = state.imageFilesResult.selectedFile;
          var selectedFilePath =
              data.imageFileByName[selectedFile]?.imageFilePath ?? '';
          var uriString =
              'http://wurb-aa-51c:8082/files/download?file_path=$selectedFilePath';
          print(uriString);
          return Image.network(uriString);

          // .builder(
          //   itemCount: fileList.length,
          //   itemBuilder: (context, index) => Card(
          //     child: ListTile(
          //       title: Text(fileList[index]),
          //       // trailing: Text(fileList[index].countryCode),
          //       trailing: Text(
          //         '${index + 1} (${fileList.length})',
          //         // '${fileList[index]}\n${index + 1} (${fileList.length})',
          //       ),
          //       onTap: () async {
          //         await showDialog(
          //             context: context, builder: (_) => ImageDialog());
          //       },

          //       // var image_path =  "http://wurb-aa-51c:8082/files/download?file_path=%2Fhome%2Fwurb%2Fwirc_recordings%2Fwirc_2024-12-28%2Fimage_20241228T135250.jpg";

          //       // Image.network(image_path);

          //       // // BlocProvider.of<FilesCubit>(context)
          //       // //     .fetchFiles(fileList[index]);
          //       // // // showSpeciesListDialog(
          //       // // //     context, fileList, index);

          //       // },
          //     ),
          //   ),
          // );
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

  BlocConsumer<ImageDirsCubit, ImageDirsState> directoryListBuilder() {
    return BlocConsumer<ImageDirsCubit, ImageDirsState>(
      listenWhen: (previous, current) {
        return true;
      },
      listener: (context, state) {
        // if (state.imageDirsResult.status ==
        //     ImageDirsStatus.initial) {
        //   context
        //       .read<ImageDirsCubit>()
        //       .filterCountryByString(filterString ?? '');
        // }
      },
      buildWhen: (previous, current) {
        return true;
      },
      builder: (context, state) {
        if (state.imageDirsResult.status == ImageDirsStatus.success) {
          var directoryList = state.imageDirsResult.availableImageDirs;

          return DropdownButton<String>(
            value: BlocProvider.of<ImageDirsCubit>(context)
                .getLastUsedSelectedImageDir(),
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
                BlocProvider.of<ImageDirsCubit>(context)
                    .setLastUsedSelectedImageDir(value!);
                // dropdownValue = value!;
                BlocProvider.of<ImageFilesCubit>(context)
                    .fetchImageFiles(value);
              });
            },
            items: directoryList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          );

          // return ListView.builder(
          //   itemCount: directoryList.length,
          //   itemBuilder: (context, index) => Card(
          //     child: ListTile(
          //       title: Text(directoryList[index]),
          //       // trailing: Text(directoryList[index].countryCode),
          //       trailing: Text(
          //         '${directoryList[index]}\n${index + 1} (${directoryList.length})',
          //       ),
          //       onTap: () {
          //         BlocProvider.of<FilesCubit>(context)
          //             .fetchFiles(directoryList[index]);
          //         // showSpeciesListDialog(
          //         //     context, directoryList, index);
          //       },
          //     ),
          //   ),
          // );
        } else if (state.imageDirsResult.status == ImageDirsStatus.initial) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state.imageDirsResult.status == ImageDirsStatus.loading) {
          return const Center(child: CupertinoActivityIndicator());
        } else if (state.imageDirsResult.status == ImageDirsStatus.failure) {
          return Center(child: Text(state.imageDirsResult.message));
        } else {
          return const Placeholder();
        }
      },
    );
  }

  BlocConsumer<ImageFilesCubit, ImageFilesState> fileListBuilder() {
    return BlocConsumer<ImageFilesCubit, ImageFilesState>(
      listenWhen: (previous, current) {
        return true;
      },
      listener: (context, state) {
        // if (state.imageDirsResult.status ==
        //     FilesStatus.initial) {
        //   context
        //       .read<FilesCubit>()
        //       .filterCountryByString(filterString ?? '');
        // }
      },
      buildWhen: (previous, current) {
        if (current.imageFilesResult.status ==
            ImageFilesStatus.selectedImageChanged) {
          return false;
        }
        return true;
      },
      builder: (context, state) {
        if (state.imageFilesResult.status == ImageFilesStatus.success) {
          var fileList = state.imageFilesResult.availableImageFiles;
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
                  BlocProvider.of<ImageFilesCubit>(context)
                      .setLastUsedSelectedFile(fileList[index]);
                  // await showDialog(
                  //     context: context, builder: (_) => ImageDialog());
                },

                // var image_path =  "http://wurb-aa-51c:8082/files/download?file_path=%2Fhome%2Fwurb%2Fwirc_recordings%2Fwirc_2024-12-28%2Fimage_20241228T135250.jpg";

                // Image.network(image_path);

                // // BlocProvider.of<FilesCubit>(context)
                // //     .fetchFiles(fileList[index]);
                // // // showSpeciesListDialog(
                // // //     context, fileList, index);

                // },
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

class ImageDialog extends StatelessWidget {
  const ImageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Image.network(
          'http://wurb-aa-51c:8082/files/download?file_path=/home/wurb/wirc_recordings/wirc_2024-12-28/image_20241228T135250.jpg'),
    );
  }
}
