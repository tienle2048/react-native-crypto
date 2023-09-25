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

interface KeyPair {
  masterSeedHd?:any
  privateKey: number[]
  publicKey: number[]
}

enum Algo {
  hdkey = "hd",
  nacl = 'nacl',
  polkadot = "polkadot"
}

export async function generateMasterKey(type: Algo, mnemonic: string, path: string): Promise<KeyPair> {
  if (Algo.hdkey === type) {
    const masterSeedHd = await AwesomeLibrary.hdkey(mnemonic, path);
    return {
      masterSeedHd: masterSeedHd,
      privateKey: masterSeedHd[1],
      publicKey: masterSeedHd[0]
    }
  }
  if (Algo.polkadot === type) {
    const masterSeedHd = await AwesomeLibrary.polkadot(mnemonic, path);
    return {
      privateKey: masterSeedHd[1],
      publicKey: masterSeedHd[0]
    }
  }
  // nacl
  const masterSeedNacl = await AwesomeLibrary.nacl(mnemonic, path);
  return {
    privateKey: masterSeedNacl[1],
    publicKey: masterSeedNacl[0]
  }
}

//  export const okla = {...AwesomeLibrary}
