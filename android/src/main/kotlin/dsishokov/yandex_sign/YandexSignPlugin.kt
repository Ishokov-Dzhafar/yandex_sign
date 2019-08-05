package dsishokov.yandex_sign

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import android.util.Base64
import android.util.Log
import java.net.URLEncoder
import java.security.spec.PKCS8EncodedKeySpec
import java.security.spec.EncodedKeySpec
import java.security.KeyFactory
import java.security.Signature

class YandexSignPlugin: MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "yandex_sign")
      channel.setMethodCallHandler(YandexSignPlugin())
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getSignUrl") {
      result.success(getSignUrl(call.arguments))
    } else {
      result.notImplemented()
    }
  }

  private fun getSignUrl(arguments: Any): String {
    val params = arguments as Map<String, *>
    val url = params["url"] as String
    val key = params["androidKey"] as String
    val data = sha256rsa(key, url)

    return data
  }

  // Формирует подпись с помощью ключа.
  fun sha256rsa(key: String, data: String): String {
    val trimmedKey = key.replace("-----BEGIN RSA PRIVATE KEY-----", "")
            .replace("-----END RSA PRIVATE KEY-----", "")
            .replace("\\s".toRegex(), "")
    Log.d("KOTLIN", trimmedKey)
    try {
      val result = Base64.decode(trimmedKey, Base64.DEFAULT)
      val factory = KeyFactory.getInstance("RSA")
      val keySpec = PKCS8EncodedKeySpec(result)
      val signature = Signature.getInstance("SHA256withRSA")
      signature.initSign(factory.generatePrivate(keySpec))
      signature.update(data.toByteArray())

      val encrypted = signature.sign()
      return URLEncoder.encode(Base64.encodeToString(encrypted, Base64.NO_WRAP), "UTF-8")
    } catch (e: Exception) {
      throw SecurityException("Error calculating cipher data. SIC!")
    }

  }
}
