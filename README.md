
# react-native-sharing-winstagram

## Getting started

`$ npm install react-native-sharing-winstagram --save`

### Mostly automatic installation

`$ react-native link react-native-sharing-winstagram`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-sharing-winstagram` and add `RNReactNativeSharingWinstagram.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNReactNativeSharingWinstagram.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`
  - Add `import com.reactlibrary.RNReactNativeSharingWinstagramPackage;` to the imports at the top of the file
  - Add `new RNReactNativeSharingWinstagramPackage()` to the list returned by the `getPackages()` method
2. Append the following lines to `android/settings.gradle`:
  	```
  	include ':react-native-sharing-winstagram'
  	project(':react-native-sharing-winstagram').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-sharing-winstagram/android')
  	```
3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
  	```
      compile project(':react-native-react-native-sharing-winstagram')
  	```

## Usage
```javascript
import RNReactNativeSharingWinstagram from 'react-native-sharing-winstagram';

// Share image to Instagram
if (RNReactNativeSharingWinstagram.canShareToInstagram) {
  RNReactNativeSharingWinstagram.shareToInstagramImageEndodedWith(base64String);
}

// Share regular Text with Url
RNReactNativeSharingWinstagram.shareText('Check this out!', 'https://docs.npmjs.com');
```
