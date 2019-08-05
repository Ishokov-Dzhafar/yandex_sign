import Flutter
import UIKit
import Security
import CommonCrypto

@available(iOS 10.0, *)
public class SwiftYandexSignPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "yandex_sign", binaryMessenger: registrar.messenger())
    let instance = SwiftYandexSignPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  @available(iOS 10.0, *)
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "getSignUrl" else {
            result(FlutterMethodNotImplemented)
            return
        }
    self.getSignUrl(result: result, arguments: call.arguments)
  }

  @available(iOS 10.0, *)
  private func getSignUrl(result: FlutterResult, arguments: Any?) {
          let params = arguments as! [String: Any]
          let url = params["url"] as! String
          let iosNameOfDerFile = params["iosNameOfDerFile"] as! String

          let signature = signString(string: url, key: loadCert(iosNameOfDerFile: iosNameOfDerFile))
          result(signature.addingPercentEncoding(withAllowedCharacters: .alphanumerics));
      }
      @available(iOS 10.0, *)
      // Зашифровывает SHA256 с помощью DER-ключа.
      func signString(string: String, key: SecKey) -> String {
          let messageData = string.data(using:String.Encoding.utf8)!
          var hash = Data(count: Int(CC_SHA256_DIGEST_LENGTH))

          _ = hash.withUnsafeMutableBytes {digestBytes in
              messageData.withUnsafeBytes {messageBytes in
                  CC_SHA256(messageBytes, CC_LONG(messageData.count), digestBytes)
              }
          }

          let signature = SecKeyCreateSignature(key,
                                                SecKeyAlgorithm.rsaSignatureDigestPKCS1v15SHA256,
                                                hash as CFData,
                                                nil) as Data?

          return (signature?.base64EncodedString())!
      }

      @available(iOS 10.0, *)
      func loadCert(iosNameOfDerFile: String) -> SecKey {
          let certificateData = NSData(
              contentsOf:Bundle.main.url(forResource: iosNameOfDerFile, withExtension: "der")!
          )
          let options: [String: Any] =
              [kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
               kSecAttrKeyClass as String: kSecAttrKeyClassPrivate,
               kSecAttrKeySizeInBits as String: 512]

          let key = SecKeyCreateWithData(certificateData!,
                                         options as CFDictionary,
                                         nil)

          return key!
      }
}
