# Welcom in 'AmBox' ;

### 1. Get the loginToken from here https://amservices.somee.com/
### 2. use this package in flutter https://github.com/AmrMAM/ambox_flutter.git
### 3. Initialize the package in main function;
#
## Examples
#### To initialize the package in main function;
```Dart
void main() async {
  await AMBox().initialize('$LoginToken');

  runApp(const MyApp());
}
```
#### Use the amBoxDB;
```Dart
    var doc = AMBox()
        .application("HelloWorld")
        .amBoxDB
        .collection("Users")
        .document("Amr_MAM")
        .collection("clients")
        .document("ahmed mmm");
    print(await doc.getData());
```

#### Or use the amBoxStorage;
```Dart
    var storage = AMBox().application("HelloWorld").amBoxStorage;
    var image = storage.folder("images").file("image1.png");
    await image.getData();

    // use this line when u need to use the image;
    Image.memory(image.fileDataUint8List);

```
#
## Please like my repo and if u have any problem sent it to check and help u solving ur problem; 
### All rights are reserved @Amr_MAM 2023;