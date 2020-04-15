package io.upsquare.flutteradform

import android.app.Activity
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** FlutterAdformPlugin */
public class FlutterAdformPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        val channel = MethodChannel(flutterPluginBinding.flutterEngine.dartExecutor, ADFORM_METHOD_CHANNEL)
        channel.setMethodCallHandler(FlutterAdformPlugin())

        flutterPluginBinding.platformViewRegistry.registerViewFactory(
                ADFORM_ADINLINE_VIEW_TYPE,
                AdformAdInlineFactory(flutterPluginBinding.binaryMessenger)
        )
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        const val ADFORM_METHOD_CHANNEL = "flutter_adform"
        const val ADFORM_ADINLINE_VIEW_TYPE = "flutter_adform/adInline"
        var activity: Activity? = null

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), ADFORM_METHOD_CHANNEL)
            channel.setMethodCallHandler(FlutterAdformPlugin())

            activity = registrar.activity()

            registrar
                    .platformViewRegistry()
                    .registerViewFactory(ADFORM_ADINLINE_VIEW_TYPE, AdformAdInlineFactory(registrar.messenger()))
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    }

    override fun onDetachedFromActivity() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }
}
