# Image Loading Optimization

This document explains the image loading optimizations implemented in the Padel Mobile app.

## Key Optimizations

### 1. OptimizedCachedImage Widget
- **Location**: `lib/configs/components/optimized_cached_image.dart`
- **Features**:
  - Memory cache optimization with device pixel ratio
  - Enhanced caching with 1-year cache headers
  - Optimized placeholder and error widgets
  - Configurable fade-in animations
  - Disk cache size limits (1000x1000px)

### 2. Specialized Image Widgets
- **CircleCachedImage**: For circular profile images
- **CourtImageWidget**: For court images with custom placeholders

### 3. Image Preloading
- **Automatic preloading**: First 5 court images and 3 booking images
- **On-demand preloading**: When user taps on court cards
- **Batch processing**: Limited concurrent downloads (max 3)
- **Background processing**: Non-blocking UI operations

### 4. Image Cache Manager
- **Location**: `lib/utils/image_cache_manager.dart`
- **Features**:
  - Cache size management
  - Batch image preloading
  - Cache clearing utilities
  - Individual image cache removal

## Performance Benefits

1. **Faster Loading**: Images load instantly when cached
2. **Reduced Network Usage**: Images are cached locally
3. **Better UX**: Smooth transitions with optimized placeholders
4. **Memory Efficient**: Proper memory cache sizing
5. **Background Processing**: Preloading doesn't block UI

## Usage Examples

### Basic Usage
```dart
OptimizedCachedImage(
  imageUrl: 'https://example.com/image.jpg',
  width: 100,
  height: 100,
  borderRadius: BorderRadius.circular(8),
)
```

### Circle Image
```dart
CircleCachedImage(
  imageUrl: 'https://example.com/profile.jpg',
  size: 50,
)
```

### Court Image
```dart
CourtImageWidget(
  imageUrl: 'https://example.com/court.jpg',
  width: 118,
  height: 95,
  borderRadius: BorderRadius.circular(10),
)
```

## Cache Management

### Clear All Cache
```dart
await ImageCacheManager.clearCache();
```

### Get Cache Size
```dart
int size = await ImageCacheManager.getCacheSize();
```

### Preload Multiple Images
```dart
await ImageCacheManager.preloadImages(
  context,
  ['url1', 'url2', 'url3'],
  maxConcurrent: 3,
);
```

## Configuration

The optimizations are automatically applied when using the new image widgets. No additional configuration is required for basic usage.

## Best Practices

1. Use `OptimizedCachedImage` for all network images
2. Use specialized widgets (`CircleCachedImage`, `CourtImageWidget`) when appropriate
3. Preload images for better user experience
4. Monitor cache size and clear when necessary
5. Use appropriate placeholder and error widgets





