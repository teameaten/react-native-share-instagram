
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

To be implemented.

## Usage
```javascript
import RNReactNativeSharingWinstagram from 'react-native-sharing-winstagram';

// Share image to Instagram
if (RNReactNativeSharingWinstagram.canShareToInstagram) {
  RNReactNativeSharingWinstagram.shareToInstagramImageEndodedWith(base64String);
}

// Share regular Text with Url
RNReactNativeSharingWinstagram.shareText('Check this out!', 'https://github.com/nascimentorafael/react-native-sharing-winstagram');
```
