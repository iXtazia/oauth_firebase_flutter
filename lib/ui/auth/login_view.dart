import 'package:flutter/material.dart';

import '../../core/theme/app_theme.dart';
import 'login_viewmodel.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key, required this.viewModel});

  final LoginViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: ListenableBuilder(
                listenable: viewModel,
                builder: (context, _) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Inkwell',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppTheme.serif,
                        fontFamilyFallback: AppTheme.serifFallback,
                        fontSize: 44,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Stories worth your time.\nSign in to start reading.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: AppTheme.muted,
                      ),
                    ),
                    const SizedBox(height: 40),
                    _ProviderButton(
                      key: const Key('google_button'),
                      label: 'Continue with Google',
                      icon: const _BrandBadge(
                        letter: 'G',
                        color: Color(0xFFDB4437),
                      ),
                      loading: viewModel.isBusyWith(AuthProviderBusy.google),
                      enabled: !viewModel.isBusy,
                      onPressed: viewModel.signInWithGoogle,
                    ),
                    const SizedBox(height: 12),
                    _ProviderButton(
                      key: const Key('facebook_button'),
                      label: 'Continue with Facebook',
                      icon: const _BrandBadge(
                        letter: 'f',
                        color: Color(0xFF1877F2),
                      ),
                      loading: viewModel.isBusyWith(AuthProviderBusy.facebook),
                      enabled: !viewModel.isBusy,
                      onPressed: viewModel.signInWithFacebook,
                    ),
                    if (viewModel.errorMessage != null) ...[
                      const SizedBox(height: 20),
                      _ErrorBanner(
                        message: viewModel.errorMessage!,
                        onClose: viewModel.dismissError,
                      ),
                    ],
                    const SizedBox(height: 32),
                    const Text(
                      'By continuing you agree to the Terms of Service and '
                      'Privacy Policy.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: AppTheme.muted),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProviderButton extends StatelessWidget {
  const _ProviderButton({
    super.key,
    required this.label,
    required this.icon,
    required this.loading,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final Widget icon;
  final bool loading;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: enabled ? onPressed : null,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(52),
        foregroundColor: AppTheme.ink,
        side: const BorderSide(color: AppTheme.ink),
        shape: const StadiumBorder(),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(alignment: Alignment.centerLeft, child: icon),
          loading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(label, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

/// Simple lettermark so no brand image assets are required.
class _BrandBadge extends StatelessWidget {
  const _BrandBadge({required this.letter, required this.color});

  final String letter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Text(
        letter,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 15,
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message, required this.onClose});

  final String message;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 4, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFDECEA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFB3261E), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              key: const Key('login_error'),
              style: const TextStyle(color: Color(0xFFB3261E), fontSize: 14),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: onClose,
          ),
        ],
      ),
    );
  }
}
