package io.opencode.sqp

import io.flutter.embedding.android.FlutterActivity
import android.os.Build
import android.view.ViewTreeObserver
import android.view.WindowManager

class MainActivity : FlutterActivity() {
    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)
        if (hasFocus) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                window.setDecorFitsSystemWindows(false)
            }
            window.decorView.setOnApplyWindowInsetsListener { view, insets ->
                view.setOnApplyWindowInsetsListener(null)
                insets
            }
        }
    }
}
