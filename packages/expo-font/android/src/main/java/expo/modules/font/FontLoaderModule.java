// Copyright 2015-present 650 Industries. All rights reserved.

package expo.modules.font;

import android.graphics.Typeface;
import android.net.Uri;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.views.text.ReactFontManager;

import java.io.File;

import androidx.annotation.NonNull;

public class FontLoaderModule extends ReactContextBaseJavaModule {
  private static final String ASSET_SCHEME = "asset://";
  private static final String EXPORTED_NAME = "ExpoFontLoader";

  public FontLoaderModule(@NonNull ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @NonNull
  @Override
  public String getName() {
    return EXPORTED_NAME;
  }

  @ReactMethod
  public void loadAsync(final String fontFamilyName, final String localUri, final Promise promise) {
    // Validate arguments
    if (fontFamilyName == null) {
      promise.reject("ERR_INVALID_ARGUMENT", "Font family name cannot be empty (null received)");
      return;
    }

    if (localUri == null) {
      promise.reject("ERR_INVALID_ARGUMENT", "Local font URI cannot be empty (null received)");
      return;
    }

    try {
      ReactFontManager.getInstance().setTypeface(fontFamilyName, Typeface.NORMAL, getTypeface(localUri));
      promise.resolve(null);
    } catch (Exception e) {
      promise.reject("ERR_UNEXPECTED", "Font loader encountered an unexpected error: " + e.getMessage(), e);
    }
  }

  protected Typeface getTypeface(String localUri) {
    if (localUri.startsWith(ASSET_SCHEME)) {
      return Typeface.createFromAsset(
        getReactApplicationContext().getAssets(),
        // Also remove the leading slash.
        localUri.substring(ASSET_SCHEME.length() + 1));
    }

    String localFontPath = Uri.parse(localUri).getPath();
    if (localFontPath == null) {
      throw new RuntimeException("Could not parse provided local font URI as a URI with a path component.");
    }
    return Typeface.createFromFile(new File(localFontPath));
  }
}
