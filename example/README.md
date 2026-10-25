# Dio Lens example

A small app showing how to set up Dio Lens:

1. `DioLens.init` with the app's navigator key (and optional settings, mode
   and export handler).
2. `DioLensInterceptor(dio: dio)` added last to the app's Dio.
3. Requests made through that Dio appear in Dio Lens; open it with the
   floating bubble or `DioLens.open()`.

Run it with:

```sh
cd example
flutter run
```

Requests go to [httpbingo.org](https://httpbingo.org), which echoes what it
receives.
