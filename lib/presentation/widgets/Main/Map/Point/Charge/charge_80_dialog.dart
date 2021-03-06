import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lseway/presentation/bloc/charge/charge.bloc.dart';
import 'package:lseway/presentation/bloc/charge/charge.event.dart';
import 'package:lseway/presentation/bloc/dialog/dialog.bloc.dart';
import 'package:lseway/presentation/bloc/dialog/dialog.event.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointInfo.event.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointinfo.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.bloc.dart';
import 'package:lseway/presentation/bloc/user/user.event.dart';
import 'package:lseway/presentation/widgets/Core/CustomButton/custom_button.dart';
import 'package:lseway/presentation/widgets/global.dart';

void showCharge80Dialog(BuildContext ctx, int pointId, {bool? dontPop}) {
  if (dontPop != true) {
    Navigator.of(ctx).pop();
  }

  var globalCtx = NavigationService.navigatorKey.currentContext;

  if (globalCtx != null) {
    BlocProvider.of<DialogBloc>(ctx).add(Toggle80Dialog(shown: true));
    Future(
      () => showDialog(
        context: globalCtx,
        barrierDismissible: true,
        useRootNavigator: true,
        barrierColor: const Color.fromRGBO(38, 38, 50, 0.2),
        builder: (dialogContext) {
          return SimpleDialog(
            backgroundColor: Theme.of(dialogContext).colorScheme.primaryVariant,
            insetPadding: const EdgeInsets.all(20),
            contentPadding: EdgeInsets.all(0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 2,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 450),
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(dialogContext).size.width - 40,
                      padding: const EdgeInsets.only(bottom: 20, top: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/green-bolt.png',
                            width: 90,
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 272),
                            child: Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                  text: '?????????????????????? ?????????????? ???? ',
                                  style: Theme.of(dialogContext)
                                      .textTheme
                                      .bodyText2
                                      ?.copyWith(fontSize: 27),
                                ),
                                TextSpan(
                                    text: '80',
                                    style: TextStyle(
                                        fontFamily: 'URWGeometricExt',
                                        fontSize: 34,
                                        foreground: Paint()
                                          ..shader = LinearGradient(
                                                  colors: [
                                                Color(0xff6BD15A),
                                                Color(0xff41C696)
                                              ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight)
                                              .createShader(const Rect.fromLTWH(
                                                  0.0, 0.0, 74, 41)))),
                                TextSpan(
                                    text: '%',
                                    style: TextStyle(
                                        fontFamily: 'URWGeometricExt',
                                        fontSize: 27,
                                        foreground: Paint()
                                          ..shader = const LinearGradient(
                                                  colors: [
                                                Color(0xff6BD15A),
                                                Color(0xff41C696)
                                              ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight)
                                              .createShader(const Rect.fromLTWH(
                                                  0.0, 0.0, 74, 41)))),
                              ]),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            '???????????? ???????????????????? ???????????????',
                            style: Theme.of(dialogContext)
                                .textTheme
                                .bodyText1
                                ?.copyWith(
                                    color: const Color(0xff1A1D21),
                                    fontSize: 18),
                          ),
                          const SizedBox(
                            height: 45,
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 272),
                            child: CustomButton(
                                text: '????????????????????',
                                type: ButtonTypes.SECONDARY,
                                bgColor: const Color(0xffEDEDF3),
                                onPress: () {
                                  Navigator.of(dialogContext).pop();
                                  BlocProvider.of<DialogBloc>(ctx).add(Toggle80Dialog(shown: false));
                                  BlocProvider.of<PointInfoBloc>(globalCtx)
                                      .add(ShowPoint(pointId: pointId));
                                }),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 272),
                            child: CustomButton(
                                text: '??????????????????',
                                type: ButtonTypes.PRIMARY,
                                postfix:
                                    SvgPicture.asset('assets/chevron-red.svg'),
                                onPress: () {
                                  Navigator.of(dialogContext).pop();
                                  showConfirmationDialog(globalCtx, pointId);
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

void showConfirmationDialog(BuildContext globalCtx, int pointId) {
  Future(
    () => showDialog(
      context: globalCtx,
      barrierDismissible: true,
      useRootNavigator: true,
      barrierColor: const Color.fromRGBO(38, 38, 50, 0.2),
      builder: (dialogContext) {
        return SimpleDialog(
          backgroundColor: Theme.of(dialogContext).colorScheme.primaryVariant,
          insetPadding: const EdgeInsets.all(20),
          contentPadding: EdgeInsets.all(0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          elevation: 2,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 450),
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(dialogContext).size.width - 40,
                    padding: const EdgeInsets.only(bottom: 20, top: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/green-bolt.png',
                          width: 90,
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 272),
                          child: Text.rich(
                            TextSpan(children: [
                              TextSpan(
                                text: '?????????????????? ?????????????? ???????????? ???? 80%?',
                                style: Theme.of(dialogContext)
                                    .textTheme
                                    .bodyText2
                                    ?.copyWith(fontSize: 27),
                              ),
                            ]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          '?????????? ?????????? ???????????????? ?? ??????????????',
                          style: Theme.of(dialogContext)
                              .textTheme
                              .bodyText1
                              ?.copyWith(
                                  color: const Color(0xff1A1D21), fontSize: 18),
                        ),
                        const SizedBox(
                          height: 45,
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 272),
                          child: CustomButton(
                              text: '??????',
                              type: ButtonTypes.SECONDARY,
                              bgColor: const Color(0xffEDEDF3),
                              onPress: () {
                                BlocProvider.of<ChargeBloc>(globalCtx)
                                    .add(StopCharge(pointId: pointId));
                                Navigator.of(dialogContext).pop();
                              }),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 272),
                          child: CustomButton(
                              text: '????!',
                              type: ButtonTypes.PRIMARY,
                              onPress: () {
                                BlocProvider.of<ChargeBloc>(globalCtx)
                                    .add(StopCharge(pointId: pointId));
                                var phone =
                                    BlocProvider.of<UserBloc>(dialogContext)
                                        .state
                                        .user!
                                        .phone;
                                BlocProvider.of<UserBloc>(dialogContext).add(
                                    Toggle80Percent(
                                        phone: phone, aggree: true));

                                Navigator.of(dialogContext).pop();
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    ),
  ).then((value){
    BlocProvider.of<DialogBloc>(globalCtx).add(Toggle80Dialog(shown: false));
  });
}
