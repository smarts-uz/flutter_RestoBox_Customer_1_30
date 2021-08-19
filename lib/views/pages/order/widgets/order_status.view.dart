import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:timelines/timelines.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/order_details.vm.dart';
import 'package:jiffy/jiffy.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fuodz/translations/order_details.i18n.dart';

class OrderStatusView extends StatelessWidget {
  const OrderStatusView(this.vm, {Key key}) : super(key: key);

  final OrderDetailsViewModel vm;
  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        "Status".i18n.text.gray500.medium.sm.make(),
        vm.order.status
            .allWordsCapitilize()
            .text
            .color(AppColor.getStausColor(vm.order.status))
            .medium
            .xl
            .make()
            .pOnly(bottom: Vx.dp20),

        //scheduled order info
        vm.order.isScheduled
            ? HStack(
                [
                  //date
                  VStack(
                    [
                      //
                      "Scheduled Date".i18n.text.gray500.medium.sm.make(),
                      "${vm.order.pickupDate}"
                          .text
                          .color(AppColor.getStausColor(vm.order.status))
                          .medium
                          .xl
                          .make()
                          .pOnly(bottom: Vx.dp20),
                    ],
                  ).expand(),
                  //time
                  VStack(
                    [
                      //
                      "Scheduled Time".i18n.text.gray500.medium.sm.make(),
                      "${Jiffy(vm.order.pickupTime).format("hh:mm a")}"
                          .text
                          .color(AppColor.getStausColor(vm.order.status))
                          .medium
                          .xl
                          .make()
                          .pOnly(bottom: Vx.dp20),
                    ],
                  ).expand(),
                ],
              )
            : UiSpacer.emptySpace(),

        //status changes
        "Order Status tracking".i18n.text.make(),

        Timeline.tileBuilder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          builder: TimelineTileBuilder.connected(
            contentsAlign: ContentsAlign.basic,
            nodePositionBuilder: (context, index) => 0.00,
            indicatorPositionBuilder: (context, index) => 0.35,
            indicatorBuilder: (context, index) {
              //
              final orderStatus = vm.order.totalStatuses[index];
              //
              return (orderStatus.passed ?? true)
                  ? DotIndicator(
                      color: AppColor.primaryColor,
                      size: 24,
                      child: Icon(
                        FlutterIcons.check_ant,
                        size: 12,
                        color: Colors.white,
                      ),
                    )
                  : OutlinedDotIndicator(
                      color: AppColor.primaryColor,
                      size: 24,
                    );
            },
            connectorBuilder: (context, index, connectorType) =>
                SolidLineConnector(
              color: AppColor.primaryColor,
            ),
            contentsBuilder: (context, index) => VStack(
              [
                Text(
                  '${vm.order.totalStatuses[index].name}'.allWordsCapitilize(),
                  style: context.textTheme.bodyText1.copyWith(
                    fontSize: Vx.dp16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                //if created at is not null
                Text(
                  "${vm.order.totalStatuses[index].createdAt != null ? Jiffy(vm.order.totalStatuses[index].createdAt).format("dd MMM, yyy 'at' hh:mm a") : ''}",
                  style: context.textTheme.bodyText1.copyWith(
                    fontSize: Vx.dp16,
                    fontWeight: FontWeight.w300,
                  ),
                ),

                //track order
                (vm.order.totalStatuses[index].createdAt != null &&
                        "${vm.order.totalStatuses[index].name}" == "enroute")
                    ? CustomButton(
                        title: "Track Order".i18n,
                        icon: FlutterIcons.map_ent,
                        onPressed: vm.trackOrder,
                        loading: vm.busy(vm.order),
                      ).p20()
                    : UiSpacer.emptySpace(),
              ],
            ).p(Vx.dp20),
            itemCount: vm.order.totalStatuses.length,
          ),
        ),
      ],
    );
  }
}
