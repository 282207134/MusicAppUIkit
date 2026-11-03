import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_theme.dart';
import '../core/music_store.dart';
import '../widgets/music_widgets.dart';

bool validEmail(String value) =>
    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim());

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) => AppPage(
    id: 'onboarding',
    footer: GradientButton(
      key: const ValueKey('get_started'),
      label: 'Get Started',
      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
    ),
    child: LayoutBuilder(
      builder: (context, bounds) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: bounds.maxHeight),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 390,
                height: bounds.maxHeight > 580 ? 440 : 330,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      for (var i = 7; i >= 0; i--)
                        Container(
                          width: 98 + i * 39.0,
                          height: 98 + i * 39.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              colors: [
                                AppColors.coral.withValues(
                                  alpha: .13 + (7 - i) * .10,
                                ),
                                AppColors.pink.withValues(
                                  alpha: .08 + (7 - i) * .105,
                                ),
                              ],
                            ),
                          ),
                        ),
                      Container(
                        width: 98,
                        height: 98,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: AppColors.gradient,
                        ),
                        child: const Icon(Icons.mic_rounded, size: 45),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Listen To Your '),
                    TextSpan(
                      text: 'Heart',
                      style: TextStyle(color: AppColors.pink),
                    ),
                  ],
                ),
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 22),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Best Free Music Streaming Services\nThe free version of Music works a bit differently from the other services',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.8,
                    color: AppColors.muted,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    ),
  );
}

class FormFieldBlock extends StatefulWidget {
  const FormFieldBlock({
    super.key,
    required this.label,
    required this.controller,
    this.password = false,
    this.email = false,
    this.validator,
    this.hint,
  });
  final String label;
  final TextEditingController controller;
  final bool password, email;
  final String? Function(String?)? validator;
  final String? hint;
  @override
  State<FormFieldBlock> createState() => _FormFieldBlockState();
}

class _FormFieldBlockState extends State<FormFieldBlock> {
  bool hidden = true;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: const TextStyle(fontSize: 16, height: 1.2)),
        const SizedBox(height: 12),
        TextFormField(
          key: ValueKey(
            'field_${widget.label.toLowerCase().replaceAll(' ', '_')}',
          ),
          controller: widget.controller,
          obscureText: widget.password && hidden,
          validator: widget.validator,
          autocorrect: !widget.password && !widget.email,
          enableSuggestions: !widget.password,
          keyboardType: widget.email
              ? TextInputType.emailAddress
              : TextInputType.text,
          style: const TextStyle(fontSize: 14),
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            hintText: widget.hint,
            suffixIcon: widget.password
                ? IconButton(
                    tooltip: hidden ? 'Show password' : 'Hide password',
                    onPressed: () => setState(() => hidden = !hidden),
                    icon: Icon(
                      hidden
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 21,
                      color: AppColors.muted,
                    ),
                  )
                : null,
          ),
        ),
      ],
    ),
  );
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.register = false});
  final bool register;
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController(text: 'jessicarae@gmail.com');
  final password = TextEditingController(text: 'music123');
  final username = TextEditingController(text: 'jessicarae');
  bool remember = true;
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    username.dispose();
    super.dispose();
  }

  void submit() {
    if (!form.currentState!.validate()) return;
    final store = MusicScope.of(context);
    store.signIn(
      email.text.trim(),
      username: widget.register ? username.text : null,
      remember: widget.register || remember,
    );
    if (widget.register) {
      Navigator.pushNamed(context, '/otp');
    } else {
      goHome(context);
    }
  }

  @override
  Widget build(BuildContext context) => AppPage(
    id: widget.register ? 'register' : 'login',
    footer: GradientButton(
      key: const ValueKey('auth_submit'),
      label: widget.register ? 'Register' : 'Login',
      onPressed: submit,
    ),
    child: Form(
      key: form,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(32, 102, 32, 24),
        children: [
          const Text(
            'Login in to Music',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                widget.register
                    ? 'Already have an account? '
                    : 'Don’t have an account? ',
                style: const TextStyle(fontSize: 14, color: AppColors.muted),
              ),
              InkWell(
                key: const ValueKey('auth_switch'),
                onTap: () => Navigator.pushReplacementNamed(
                  context,
                  widget.register ? '/login' : '/register',
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    widget.register ? 'Sign In' : 'Sign Up',
                    style: const TextStyle(fontSize: 14, color: AppColors.pink),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 34),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _social(Icons.apple, const Color(0xFF969CA4), 'Apple'),
              const SizedBox(width: 16),
              _social(null, const Color(0xFFFF4045), 'Google'),
              const SizedBox(width: 16),
              _social(Icons.facebook, const Color(0xFF34598E), 'Facebook'),
            ],
          ),
          const SizedBox(height: 30),
          const Row(
            children: [
              Expanded(child: Divider(color: AppColors.muted)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('OR', style: TextStyle(fontSize: 14)),
              ),
              Expanded(child: Divider(color: AppColors.muted)),
            ],
          ),
          const SizedBox(height: 34),
          if (widget.register)
            FormFieldBlock(
              label: 'Username',
              controller: username,
              validator: (v) =>
                  (v?.trim().isEmpty ?? true) ? 'Enter your name' : null,
            ),
          FormFieldBlock(
            label: 'Email',
            controller: email,
            email: true,
            validator: (v) =>
                validEmail(v ?? '') ? null : 'Enter a valid email address',
          ),
          FormFieldBlock(
            label: 'Password',
            controller: password,
            password: true,
            validator: (v) =>
                (v?.length ?? 0) >= 6 ? null : 'Use at least 6 characters',
          ),
          if (!widget.register)
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: remember,
                        activeColor: AppColors.pink,
                        onChanged: (value) => setState(() => remember = value!),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Remember me',
                      style: TextStyle(fontSize: 13, color: AppColors.muted),
                    ),
                  ],
                ),
                TextButton(
                  key: const ValueKey('forgot_password'),
                  onPressed: () =>
                      Navigator.pushNamed(context, '/forgot_password'),
                  child: const Text(
                    'Forgot password',
                    style: TextStyle(fontSize: 13, color: AppColors.muted),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 18),
          const Text(
            'Local demo · no online account required',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.muted),
          ),
        ],
      ),
    ),
  );
  Widget _social(IconData? icon, Color color, String name) => Semantics(
    button: true,
    label: 'Continue with $name',
    child: InkWell(
      onTap: () => showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text('$name sign in'),
          content: const Text(
            'This is an offline UI demo. Continue with the sample profile to explore the app.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                MusicScope.of(context).signIn(email.text.trim());
                goHome(context);
              },
              child: const Text('Continue demo'),
            ),
          ],
        ),
      ),
      borderRadius: BorderRadius.circular(28),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: icon == null
            ? const Center(
                child: Text(
                  'G⁺',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              )
            : Icon(icon, size: 25),
      ),
    ),
  );
}

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key, this.reset = false});
  final bool reset;
  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController(text: 'jessicarae@gmail.com');
  final password = TextEditingController();
  final confirm = TextEditingController();
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    confirm.dispose();
    super.dispose();
  }

  void submit() {
    if (!form.currentState!.validate()) return;
    if (widget.reset) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      notice(context, 'Demo password reset completed. Sign in to continue.');
    } else {
      Navigator.pushNamed(context, '/otp', arguments: 'reset');
    }
  }

  @override
  Widget build(BuildContext context) => AppPage(
    id: widget.reset ? 'reset_password' : 'forgot_password',
    title: widget.reset ? 'Reset Password' : 'Forget Password',
    footer: GradientButton(
      key: const ValueKey('password_continue'),
      label: 'Continue',
      onPressed: submit,
    ),
    child: Form(
      key: form,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(32, 62, 32, 24),
        children: [
          Text(
            widget.reset ? 'Reset Password' : 'Forget Password',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.reset
                  ? 'Please enter and confirm your new password below to access your account'
                  : 'Please enter your email and we will send you a link to return to your account',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.muted,
                fontSize: 18,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 88),
          if (widget.reset) ...[
            FormFieldBlock(
              label: 'Password',
              controller: password,
              password: true,
              validator: (v) =>
                  (v?.length ?? 0) >= 6 ? null : 'Use at least 6 characters',
            ),
            FormFieldBlock(
              label: 'Confirm Password',
              controller: confirm,
              password: true,
              validator: (v) =>
                  v == password.text ? null : 'Passwords must match',
            ),
          ] else
            FormFieldBlock(
              label: 'Email',
              controller: email,
              email: true,
              validator: (v) =>
                  validEmail(v ?? '') ? null : 'Enter a valid email address',
            ),
          const SizedBox(height: 12),
          const Text(
            'Local demonstration. No email is sent.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 11, color: AppColors.muted),
          ),
        ],
      ),
    ),
  );
}

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, this.reset = false});
  final bool reset;
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final controllers = List.generate(4, (_) => TextEditingController());
  final focus = List.generate(4, (_) => FocusNode());
  Timer? timer;
  int remaining = 25;
  String? error;
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remaining == 0) {
        timer?.cancel();
      } else {
        setState(() => remaining--);
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    for (final c in controllers) {
      c.dispose();
    }
    for (final f in focus) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppPage(
    id: 'otp',
    title: 'Verification',
    footer: GradientButton(
      key: const ValueKey('otp_continue'),
      label: 'Continue',
      onPressed: () {
        if (remaining == 0) {
          setState(() => error = 'Code expired. Request a new demo code.');
          return;
        }
        if (controllers.map((c) => c.text).join() != '5724') {
          setState(() => error = 'Enter the demo code 5724.');
          return;
        }
        Navigator.pushReplacementNamed(
          context,
          widget.reset ? '/reset_password' : '/language',
        );
      },
    ),
    child: ListView(
      padding: const EdgeInsets.fromLTRB(32, 62, 32, 24),
      children: [
        const Text(
          'OTP Verification',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 20),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 26),
          child: Text(
            'We sent OTP verification to your email. This code will expire in',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, height: 1.5, color: AppColors.muted),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '00:${remaining.toString().padLeft(2, '0')}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.muted),
        ),
        const SizedBox(height: 92),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            4,
            (i) => SizedBox(
              width: 60,
              child: TextField(
                key: ValueKey('otp_$i'),
                controller: controllers[i],
                focusNode: focus[i],
                keyboardType: TextInputType.number,
                maxLength: 1,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
                decoration: const InputDecoration(
                  counterText: '',
                  hintText: '-',
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
                onChanged: (value) {
                  if (value.isNotEmpty && i < 3) focus[i + 1].requestFocus();
                  if (value.isEmpty && i > 0) focus[i - 1].requestFocus();
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Demo code: 5724',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted, fontSize: 12),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text(
              error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.pink, fontSize: 13),
            ),
          ),
        TextButton(
          onPressed: remaining > 0
              ? null
              : () {
                  setState(() {
                    remaining = 25;
                    error = null;
                  });
                  _startTimer();
                },
          child: const Text('Resend code'),
        ),
      ],
    ),
  );
}
