import WalletCore
import BIP39
import TweetNacl
import Ed25519HDKeySwift
import CryptoSwift
import Sr25519


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

  @objc(polkadot:withB:withResolver:withRejecter:)
    func polkadot(mnemonicString: String, path: String, resolve:RCTPromiseResolveBlock,reject:RCTPromiseRejectBlock) -> Void {
        do{
            let entropy = HDWallet(mnemonic: mnemonicString, passphrase: "")?.entropy.bytes
            let salt: Array<UInt8> = [109, 110, 101, 109, 111, 110, 105, 99]
            let miniSeed = try PKCS5.PBKDF2(password: entropy!, salt: salt, iterations: 2048, keyLength: 64, variant: .sha512).calculate()[0...31]
            let sr25519Seed = try Sr25519Seed(raw: Data(miniSeed))
            let publicKey = Sr25519KeyPair(seed: sr25519Seed).publicKey.raw.bytes
            resolve([publicKey,""])
        } catch {
            resolve(["",""])
        }
    }
}
