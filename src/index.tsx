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
  privateKey: number[]
  publicKey: number[]
}

type Data = String | number[][]

enum Algo {
  hdkey = "hd",
  nacl = 'nacl',
  polkadot = "polkadot"
}

enum Env {
  android = "ANDROID",
  ios = "IOS"
}

const constant = {
  env: "ENVIRONMENT"
}

const enviroment = AwesomeLibrary.getConstants()

const formatData = (data: Data)=>{
  if(enviroment[constant.env] === Env.android){
    const [publicKeyString, privateKeyString] = (data as String).split('  ')
    const [publicKey, privateKey] = [(publicKeyString as String).split(' '), (privateKeyString as String).split(' ')]
    return {
      privateKey: privateKey.map(item=>parseInt(item)) ,
      publicKey: publicKey.map(item=>parseInt(item))
    }
  }
  return {
    privateKey: data[1] as number[],
    publicKey: data[0] as number[]
  }
}


export async function generateMasterKey(type: Algo, mnemonic: string, path: string): Promise<KeyPair> {
  if (Algo.hdkey === type) {
    const masterSeedHd: Data = await AwesomeLibrary.hdkey(mnemonic, path);
    return formatData(masterSeedHd)
  }
  if (Algo.polkadot === type) {
    const masterSeedPolkadot = await AwesomeLibrary.polkadot(mnemonic, path);
    return formatData(masterSeedPolkadot)
  }
  // nacl
  const masterSeedNacl = await AwesomeLibrary.nacl(mnemonic, path);
  return formatData(masterSeedNacl)
}

 export const okla = {...AwesomeLibrary}
