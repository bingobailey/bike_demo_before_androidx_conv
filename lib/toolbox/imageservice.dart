
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart';


class ImageService {

 

  Future<Map> uploadImage({File imageFile}) async {

    // this is the service we call to upload the image
    String url = "http://www.mtbphotoz.com/bikedemo/php/XuploadPhoto.php";
   
    // This is the directory where the image files will be kept, specific to
    // each user. Each user should get an assigned photoKeyStore (ie dir)
    String photoKeyStore = "howdee";  

    // Get the extension
    String fileExtension = extension(imageFile.path);

    // If it doesn't have an extension, let's default it to jpg
    if( fileExtension.length==0 ) {
      print("no extension detected");
      fileExtension=".jpg";
    }
    
    // Let's compose the imagename
    // NOTE: This would be the image name that would be stored in the db. 
    String imageName =  basename(imageFile.path) +  fileExtension;

    // Convert it to a base64 string so we can send it
    List<int> imageBytes = imageFile.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    // Lets set the headers.  NOTE that application/w-www-form-urlencoded works
    // when sending base64 string.  Json and multi-part do not. 
    var headers = {
       HttpHeaders.CONTENT_TYPE: "application/x-www-form-urlencoded",
       HttpHeaders.ACCEPT : "application/json",
      };  


    http.Response response = await http.post(url,
              headers: headers ,
              body: {
                "imageData": base64Image,
                "imageName" :imageName,
                "photoKeyStore" : photoKeyStore,
              }
            );

      if (response.statusCode==200) { // Server returned OK
        Map<String, dynamic> result = jsonDecode(response.body);
        return result;

      } else { 
          // Server Did NOT return OK, We may have a problem... 
          var result = {"statusCode":response.statusCode, "statusMessage":"HTTP Error"};
          return result;
      } 
    
    }


} // End of imageservice class