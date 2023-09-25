package com.awesomelibrary;

import androidx.annotation.NonNull;


import android.util.Log;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.module.annotations.ReactModule;
import wallet.core.jni.HDWallet;
import wallet.core.jni.CoinType;
import wallet.core.jni.PrivateKey;
import wallet.core.jni.PublicKeyType;
@ReactModule(name = AwesomeLibraryModule.NAME)
public class AwesomeLibraryModule extends ReactContextBaseJavaModule {
  public static final String NAME = "AwesomeLibrary";

  public AwesomeLibraryModule(ReactApplicationContext reactContext) {
    super(reactContext);
    System.loadLibrary("TrustWalletCore");
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }


  // Example method
  // See https://reactnative.dev/docs/native-modules-android

  String convertByteArrayToString(byte[] publicKeyBase64, byte[] privateKeyBase64){
    String publicKeyString = "";
    String privateKeyString = "";
    for (var i = 0; i < publicKeyBase64.length; i++) {
      publicKeyString += String.valueOf(publicKeyBase64[i] & 0xff) + " ";
    }
    for (var i = 0; i < privateKeyBase64.length; i++) {
      privateKeyString += " " + String.valueOf(privateKeyBase64[i] & 0xff);
    }
    return publicKeyString + privateKeyString;
  }

  @ReactMethod
  public void hdkey(String mnemonic , String path, Promise promise) {
    var wallet = new HDWallet(mnemonic, "");
    PrivateKey key = wallet.getKey(CoinType.ETHEREUM , path);
    byte[] publicKeyBase64 = key.getPublicKeyByType(PublicKeyType.SECP256K1).data();
    byte[] privateKeyBase64 = key.data();
    String result = convertByteArrayToString(publicKeyBase64,privateKeyBase64);
    promise.resolve(result);
  }

  @ReactMethod
  public void nacl(String mnemonic , String path, Promise promise) {
    var wallet = new HDWallet(mnemonic, "");
    promise.resolve(1);
  }

  @ReactMethod
  public void polkadot(String mnemonic , String path, Promise promise) {
    promise.resolve(1);
  }
}
