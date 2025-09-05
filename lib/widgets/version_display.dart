import 'package:flutter/material.dart';
import '../services/version_service.dart';

class VersionDisplay extends StatefulWidget {
  final bool showBuildNumber;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final bool showLoadingState;
  
  const VersionDisplay({
    super.key,
    this.showBuildNumber = true,
    this.textStyle,
    this.backgroundColor,
    this.padding,
    this.borderRadius,
    this.showLoadingState = false,
  });
  
  @override
  State<VersionDisplay> createState() => _VersionDisplayState();
}

class _VersionDisplayState extends State<VersionDisplay> {
  bool _isLoading = false;
  String? _error;
  
  @override
  void initState() {
    super.initState();
    _checkInitialization();
  }
  
  void _checkInitialization() {
    if (!VersionService.isInitialized && widget.showLoadingState) {
      setState(() {
        _isLoading = true;
      });
      
      VersionService.reinitialize().then((success) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _error = success ? null : '版本信息获取失败';
          });
        }
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading && widget.showLoadingState) {
      return Container(
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: widget.backgroundColor ?? const Color(0xFF4CAF50).withValues(alpha: 0.2),
          borderRadius: widget.borderRadius ?? BorderRadius.circular(6),
        ),
        child: const SizedBox(
          width: 12,
          height: 12,
          child: CircularProgressIndicator(
            strokeWidth: 1.5,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
          ),
        ),
      );
    }
    
    if (_error != null) {
      return Container(
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red.withValues(alpha: 0.2),
          borderRadius: widget.borderRadius ?? BorderRadius.circular(6),
        ),
        child: Text(
          _error!,
          style: widget.textStyle ?? const TextStyle(
            fontSize: 12,
            color: Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    
    final versionText = widget.showBuildNumber 
        ? VersionService.formattedVersion
        : 'v${VersionService.version}';
    
    return Container(
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? const Color(0xFF4CAF50).withValues(alpha: 0.2),
        borderRadius: widget.borderRadius ?? BorderRadius.circular(6),
      ),
      child: Text(
        versionText,
        style: widget.textStyle ?? const TextStyle(
          fontSize: 12,
          color: Color(0xFF4CAF50),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}