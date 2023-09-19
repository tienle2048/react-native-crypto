import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-awesome-library' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

const AwesomeLibrary = NativeModules.AwesomeLibrary
  ? NativeModules.AwesomeLibrary
  : new Proxy(
    {},
    {
      get() {
        throw new Error(LINKING_ERROR);
      },
    }
  );

const algo = {
  hdkey: "hdkey",
  nacl: 'nacl'
}

export function generateMasterKey(type: string, mnemonic: string, path: string): Promise<string> {
  if (algo.hdkey ===type) return AwesomeLibrary.hdkey(mnemonic, path);
  if (algo.nacl ===type) return AwesomeLibrary.nacl(mnemonic, path);
  return AwesomeLibrary.hdkey(mnemonic, path);
}
