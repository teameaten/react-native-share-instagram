# react-native-share-instagram

## Getting started

`$ yarn add @micabe/react-native-share-instagram`

## Automatic installation

`$ react-native link @micabe/react-native-share-instagram`


## Usage
```javascript
import RNReactNativeSharingWinstagram from 'react-native-sharing-winstagram';

RNReactNativeSharingWinstagram.shareWithInstagram(this.state.fileName, this.state.picture, message => {
  if (message) alert(message)
}, error => {
  alert(error.message) // error callback for IOs only
})
```

### Troubleshouting

* Make sure you have authorised in `Info.plist` your app to communicate with the Instagram app (iOS):

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>instagram</string>
</array>

<key>NSPhotoLibraryUsageDescription</key>
<string>This app requires access to the photo library to share on Instagram.</string>
```
