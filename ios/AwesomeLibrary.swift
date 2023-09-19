import WalletCore
import BIP39
import TweetNacl
import Ed25519HDKeySwift


@objc(AwesomeLibrary)
class AwesomeLibrary: NSObject {

  @objc(hdkey:withB:withResolver:withRejecter:)
  func hdkey(mnemonicString: String, path: String, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
    let wallet = HDWallet(mnemonic: mnemonicString, passphrase: "")!
    let key = wallet.getKey(coin: CoinType.ethereum , derivationPath: path)
    let publicKeyBase64 = key.getPublicKeyByType(pubkeyType: PublicKeyType.secp256k1).data.bytes
    let privateKeyBase64 = key.data.bytes
      resolve([publicKeyBase64,privateKeyBase64])
  }

  @objc(nacl:withB:withResolver:withRejecter:)
  func nacl(mnemonicString: String, path: String, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
      let preSeed: Data
      do{
          let seed = HDWallet(mnemonic: mnemonicString, passphrase: "")!.seed
          if(path == "m") {
              preSeed = Data(seed.bytes[0...31])
          } else {
              preSeed = try Ed25519HDKey.derivePath(path, seed: seed.toHexString()).key
          }
          let masterSeed = try NaclSign.KeyPair.keyPair(fromSeed: preSeed)
          
          let publicKeyBase64 = masterSeed.publicKey.bytes
          let privateKeyBase64 = masterSeed.secretKey.bytes
          resolve([publicKeyBase64,privateKeyBase64])
      } catch {
          resolve(["",""])
      }
  }
}
