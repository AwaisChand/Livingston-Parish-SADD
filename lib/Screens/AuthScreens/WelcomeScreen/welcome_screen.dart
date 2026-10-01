import 'package:dp_sad/Common/AppAssets/app_assets.dart';
import 'package:dp_sad/Common/AppColors/app_colors.dart';
import 'package:dp_sad/Common/AppTextStyle/app_text_style.dart';
import 'package:dp_sad/Common/AppTexts/app_texts.dart';
import 'package:dp_sad/Common/Config/size_config.dart';
import 'package:dp_sad/Screens/AuthScreens/WelcomeScreen/welcome_motion.dart';
import 'package:dp_sad/Screens/HomeScreen/home_screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, required this.displayName});

  final String displayName;

  static Route<void> route({required String displayName}) {
    return PageRouteBuilder<void>(
      transitionDuration: WelcomeMotion.route,
      reverseTransitionDuration: WelcomeMotion.route,
      pageBuilder: (_, _, _) => WelcomeScreen(displayName: displayName),
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _logo;
  late final CurvedAnimation _label;
  late final CurvedAnimation _name;
  late final CurvedAnimation _rule;
  late final CurvedAnimation _subtitle;
  late final CurvedAnimation _action;
  late final List<CurvedAnimation> _ripples;
  bool _openedHome = false;
  bool _started = false;

  String? get _givenName {
    final trimmed = widget.displayName.trim();
    if (trimmed.isEmpty) return null;
    final first = trimmed.split(RegExp(r'\s+')).first;
    return first.isEmpty ? null : first;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: WelcomeMotion.sequence,
    );
    _logo = CurvedAnimation(parent: _controller, curve: WelcomeMotion.logo);
    _label = CurvedAnimation(parent: _controller, curve: WelcomeMotion.label);
    _name = CurvedAnimation(parent: _controller, curve: WelcomeMotion.name);
    _rule = CurvedAnimation(parent: _controller, curve: WelcomeMotion.rule);
    _subtitle = CurvedAnimation(
      parent: _controller,
      curve: WelcomeMotion.subtitle,
    );
    _action = CurvedAnimation(parent: _controller, curve: WelcomeMotion.action);
    _ripples = List<CurvedAnimation>.generate(
      WelcomeMotion.rippleCount,
      (index) => CurvedAnimation(
        parent: _controller,
        curve: WelcomeMotion.ripple(index),
      ),
    );
    _controller.addStatusListener(_onStatus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SizeConfig().init(context);
    if (_started) return;
    _started = true;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    _controller.duration =
        reduceMotion ? WelcomeMotion.reduced : WelcomeMotion.sequence;
    _controller.forward();
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _openHome();
    }
  }

  void _openHome() {
    if (_openedHome || !mounted) return;
    _openedHome = true;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: WelcomeMotion.route,
        pageBuilder: (_, _, _) => const HomeScreen(),
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_onStatus);
    _logo.dispose();
    _label.dispose();
    _name.dispose();
    _rule.dispose();
    _subtitle.dispose();
    _action.dispose();
    for (final ripple in _ripples) {
      ripple.dispose();
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final givenName = _givenName;

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.whiteColor, AppColors.lightBlueColor],
          ),
        ),
        child: SafeArea(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _openHome,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return Column(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return FittedBox(
                            fit: BoxFit.scaleDown,
                            child: SizedBox(
                              width: constraints.maxWidth,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _WelcomeMark(logo: _logo, ripples: _ripples),
                                  SizedBox(height: getHeight(28)),
                                  _FadeSlide(
                                    animation: _label,
                                    child: Text(
                                      AppTexts.welcomeLabel.toUpperCase(),
                                      style: AppTextStyle.welcomeLabel,
                                    ),
                                  ),
                                  if (givenName != null) ...[
                                    SizedBox(height: getHeight(8)),
                                    _FadeSlide(
                                      animation: _name,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: getWidth(32),
                                        ),
                                        child: Text(
                                          givenName,
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyle.welcomeName,
                                        ),
                                      ),
                                    ),
                                  ],
                                  SizedBox(height: getHeight(16)),
                                  _Rule(animation: _rule),
                                  SizedBox(height: getHeight(16)),
                                  _FadeSlide(
                                    animation: _subtitle,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: getWidth(40),
                                      ),
                                      child: Text(
                                        AppTexts.welcomeSubtitle,
                                        textAlign: TextAlign.center,
                                        style: AppTextStyle.welcomeSubtitle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Opacity(
                      opacity: _action.value,
                      child: Text(
                        AppTexts.welcomeContinue,
                        style: AppTextStyle.welcomeAction,
                      ),
                    ),
                    SizedBox(height: getHeight(18)),
                    _SequenceBar(progress: _controller.value),
                    SizedBox(height: getHeight(12)),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeMark extends StatelessWidget {
  const _WelcomeMark({required this.logo, required this.ripples});

  final Animation<double> logo;
  final List<CurvedAnimation> ripples;

  @override
  Widget build(BuildContext context) {
    final shortest = MediaQuery.sizeOf(context).shortestSide;
    final seal = (shortest * 0.34).clamp(112.0, 156.0);

    return SizedBox(
      width: seal * 1.8,
      height: seal * 1.8,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (final ripple in ripples)
            _Ripple(animation: ripple, diameter: seal * 1.7),
          Opacity(
            opacity: logo.value.clamp(0, 1),
            child: Transform.scale(
              scale: 0.86 + (0.14 * logo.value.clamp(0, 1)),
              child: Container(
                width: seal,
                height: seal,
                padding: EdgeInsets.all(seal * 0.16),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.deepPurpleColor.withValues(alpha: 0.08),
                      blurRadius: 28,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Ripple extends AnimatedWidget {
  const _Ripple({required Animation<double> animation, required this.diameter})
    : super(listenable: animation);

  final double diameter;

  Animation<double> get _progress => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final t = _progress.value.clamp(0.0, 1.0);
    return Opacity(
      opacity: (1 - t) * 0.55,
      child: Transform.scale(
        scale: 0.45 + (0.55 * t),
        child: Container(
          width: diameter,
          height: diameter,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryColor,
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _FadeSlide extends StatelessWidget {
  const _FadeSlide({required this.animation, required this.child});

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final t = animation.value.clamp(0.0, 1.0);
    return Opacity(
      opacity: t,
      child: Transform.translate(
        offset: Offset(0, (1 - t) * 14),
        child: child,
      ),
    );
  }
}

class _Rule extends StatelessWidget {
  const _Rule({required this.animation});

  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: SizedBox(
        width: getWidth(56) * animation.value.clamp(0, 1),
        height: 2,
        child: const DecoratedBox(
          decoration: BoxDecoration(color: AppColors.primaryColor),
        ),
      ),
    );
  }
}

class _SequenceBar extends StatelessWidget {
  const _SequenceBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: getWidth(48)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: LinearProgressIndicator(
          minHeight: 2,
          value: progress.clamp(0, 1),
          backgroundColor: AppColors.primaryColor.withValues(alpha: 0.12),
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
