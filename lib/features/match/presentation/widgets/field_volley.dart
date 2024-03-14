// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/size.dart';
import 'package:scouting_tracker_beach_volley/core/constants/device/theme.dart';

import 'package:scouting_tracker_beach_volley/features/match/domain/entites/beat_Action.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/ball_line_cubit/ball_line_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/get_beats_cubit/get_beats_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/invert_cubit/invert_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/reset_line_cubit/reset_line_cubit.dart';
import 'package:scouting_tracker_beach_volley/features/match/presentation/state_managments/show_player_on_field_cubit/show_player_on_field_cubit.dart';

class VolleyballField extends StatefulWidget {
  List<Map>? lines;
  bool? isShowStatics;
  bool? isBeat;

  VolleyballField({this.isShowStatics, this.lines, this.isBeat});
  @override
  _VolleyballFieldState createState() => _VolleyballFieldState();
}

class _VolleyballFieldState extends State<VolleyballField> {
  Offset? startPoint;
  Offset? endPoint;
  bool firstTap = true;
  bool? continuedLine;
  bool? drawedLine = false;
  @override
  Widget build(BuildContext context) {
    Size size = device(context);
    return BlocListener<ResetLineCubit, ResetLineState>(
      listener: (context, reset) {
        if (reset is ResetNowState) {
          startPoint = null;
          endPoint = null;
          firstTap = true;
          continuedLine = null;
          drawedLine = false;
          setState(() {});
        }
      },
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          if (details.localPosition.dx > 0 &&
              details.localPosition.dx < 300 &&
              details.localPosition.dy > 0 &&
              details.localPosition.dy < 150) {
            setState(() {
              if (drawedLine == false) {
                if (firstTap == true) {
                  startPoint = details.localPosition;
                  firstTap = false;
                } else {
                  endPoint = details.localPosition;
                  drawedLine = true;
                  continuedLine = false;
                }
              }
            });
          }
        },
        onPanUpdate: (details) {
          if (details.localPosition.dx > 0 &&
              details.localPosition.dx < 300 &&
              details.localPosition.dy > 0 &&
              details.localPosition.dy < 150) {
            setState(() {
              if (firstTap == true) {
                startPoint = details.localPosition;
                firstTap = false;
              } else {
                drawedLine == true ? null : endPoint = details.localPosition;
              }
            });
          }
        },
        child: Container(
          color: Colors.white,
          child: BlocBuilder<InvertCubit, InvertState>(
            builder: (context, invert) {
              bool inverted =
                  invert is InvertNewState ? invert.inverted : false;
              bool blueInverted =
                  invert is InvertNewState ? invert.blueInverted : false;
              bool redInverted =
                  invert is InvertNewState ? invert.redInverted : false;

              return BlocBuilder<ShowPlayerOnFieldCubit,
                  ShowPlayerOnFieldState>(
                builder: (context, state) {
                  if (state is ShowNewPlayerOnFieldState) {
                    return Stack(
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final fieldWidth = constraints.maxWidth;
                            final fieldHeight = constraints.maxHeight;

                            return startPoint != null && endPoint != null
                                ? continuedLine == false
                                    ? CustomPaint(
                                        painter:
                                            DiscontinuedLineWithBorderPainter(
                                                isShowStatics:
                                                    widget.isShowStatics,
                                                context: context,
                                                fieldWidth: fieldWidth,
                                                fieldHeight: fieldHeight,
                                                beatsLines: widget.lines,
                                                startPoint: startPoint!,
                                                endPoint: endPoint!))
                                    : CustomPaint(
                                        painter: FieldWithBorderPainter(
                                            context: context,
                                            isShowStatics: widget.isShowStatics,
                                            fieldWidth: fieldWidth,
                                            fieldHeight: fieldHeight,
                                            beatsLines: widget.lines,
                                            startPoint: startPoint!,
                                            endPoint: endPoint!))
                                : CustomPaint(
                                    painter: DiscontinuedLineWithBorderPainter(
                                        isShowStatics: widget.isShowStatics,
                                        context: context,
                                        beatsLines: widget.lines,
                                        fieldWidth: fieldWidth,
                                        fieldHeight: fieldHeight,
                                        startPoint: startPoint ?? Offset.zero,
                                        transparent: true,
                                        endPoint: endPoint ?? Offset.zero));
                          },
                        ),
                        widget.isBeat != null && state.redTeam == false
                            ? Positioned(
                                bottom: blueInverted == false
                                    ? size.height * -0.005
                                    : null,
                                top: blueInverted == true
                                    ? size.height * -0.005
                                    : null,
                                left: inverted == false
                                    ? size.width * 0.00
                                    : null,
                                right:
                                    inverted == true ? size.width * 0.00 : null,
                                child: Container(
                                 height: 150,
                                  width: 4,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                  ),
                                ),
                              )
                            : SizedBox(),
                        widget.isBeat != null && state.redTeam == true
                            ? Positioned(
                                right: size.width * 0.00,
                                child: Container(
                                  height: 150,
                                  width: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    );
                  } else {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        final fieldWidth = constraints.maxWidth;
                        final fieldHeight = constraints.maxHeight;

                        return startPoint != null && endPoint != null
                            ? continuedLine == false
                                ? CustomPaint(
                                    painter: DiscontinuedLineWithBorderPainter(
                                        isShowStatics: widget.isShowStatics,
                                        context: context,
                                        fieldWidth: fieldWidth,
                                        fieldHeight: fieldHeight,
                                        beatsLines: widget.lines,
                                        startPoint: startPoint!,
                                        endPoint: endPoint!))
                                : CustomPaint(
                                    painter: FieldWithBorderPainter(
                                        context: context,
                                        isShowStatics: widget.isShowStatics,
                                        fieldWidth: fieldWidth,
                                        fieldHeight: fieldHeight,
                                        beatsLines: widget.lines,
                                        startPoint: startPoint!,
                                        endPoint: endPoint!))
                            : CustomPaint(
                                painter: DiscontinuedLineWithBorderPainter(
                                    isShowStatics: widget.isShowStatics,
                                    context: context,
                                    beatsLines: widget.lines,
                                    fieldWidth: fieldWidth,
                                    fieldHeight: fieldHeight,
                                    startPoint: startPoint ?? Offset.zero,
                                    transparent: true,
                                    endPoint: endPoint ?? Offset.zero));
                      },
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class DiscontinuedLineWithBorderPainter extends CustomPainter {
  final double fieldWidth;
  final double fieldHeight;
  final Offset startPoint;
  final Offset endPoint;
  final bool? isShowStatics;
  final bool? transparent;
  final double borderMargin;
  final BuildContext context;

  final List? beatsLines;
  DiscontinuedLineWithBorderPainter({
    required this.fieldWidth,
    required this.fieldHeight,
    this.beatsLines,
    required this.startPoint,
    required this.endPoint,
    required this.isShowStatics,
    this.transparent,
    this.borderMargin = 20.0, // Set the margin value
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white // Change the color as needed
      ..style = PaintingStyle.fill;

    // Calculate the actual field dimensions with the margin

    final double actualFieldWidth = fieldWidth - 2 * borderMargin;
    final double actualFieldHeight = fieldHeight - 2 * borderMargin;
    final double fieldX = borderMargin;
    final double fieldY = borderMargin;

    // Draw the border
    canvas.drawRect(
      Rect.fromLTRB(0, 0, fieldWidth, fieldHeight),
      Paint()
        ..color = Colors.grey // Set the border color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4, // Set the border thickness
    );

    // Draw the volleyball field
    canvas.drawRect(
      Rect.fromLTRB(fieldX, fieldY, fieldX + actualFieldWidth,
          fieldY + actualFieldHeight),
      paint,
    );

    // Draw the wall line in the middle
    final wallLineX = fieldX + actualFieldWidth / 2;
    canvas.drawLine(
      Offset(wallLineX, fieldY),
      Offset(wallLineX, fieldY + actualFieldHeight),
      Paint()
        ..color = Colors.white // Change the color as needed
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2, // Change the line thickness as needed
    );

    // Draw horizontal lines (4 lines)
    final sectionHeight = actualFieldHeight / 5;
    for (int i = 0; i <= 5; i++) {
      final yOffset = fieldY + i * sectionHeight;
      canvas.drawLine(
        Offset(fieldX, yOffset),
        Offset(fieldX + actualFieldWidth, yOffset),
        Paint()
          ..color = Colors.blueAccent // Change the color as needed
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1, // Change the line thickness as needed
      );
    }

    // Draw vertical lines (9 lines)
    final sectionWidth = actualFieldWidth / 8;
    for (int i = 0; i < 9; i++) {
      final xOffset = fieldX + i * sectionWidth;
      canvas.drawLine(
        Offset(xOffset, fieldY),
        Offset(xOffset, fieldY + actualFieldHeight),
        Paint()
          ..color = i == 4
              ? Colors.blue[900]!
              : Colors.blueAccent // Change the color as needed
          ..style = PaintingStyle.stroke
          ..strokeWidth = i == 4 ? 2 : 1, // Change the line thickness as needed
      );
    }

    if (isShowStatics == true) {
      if (beatsLines != null) {
        for (int i = 0; beatsLines!.length > i; i++) {
          if (beatsLines![i]['continued']) {
            canvas.drawLine(
              beatsLines![i]['p1'],
              beatsLines![i]['p2'],

              Paint()
                ..color =
                    beatsLines![i]['color'] // Change the line color as needed
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2, // Change the line thickness as needed
            );

            // Draw an icon at the midpoint
            // Draw an icon at the end of the line
            if(!(beatsLines![i]['p1'] == Offset.zero && beatsLines![i]['p2'] ==Offset.zero)){
                drawIconAtEnd(
                canvas, beatsLines![i]['p2'], beatsLines![i]['color']);
            }
          } else {
            Offset startPoint = beatsLines![i]['p1'];
            Offset endPoint = beatsLines![i]['p2'];
            if (startPoint != null && endPoint != null) {
              Paint linePaint = Paint()
                ..color =
                    beatsLines![i]['color'] // Change the line color as needed
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2;

              // Define the length of each dash and gap in the dashed line
              const dashLength = 5.0;
              const gapLength = 2;

              // Calculate the length and direction of the line segment
              final lineLength = (endPoint - startPoint).distance;
              final lineDirection = (endPoint - startPoint).direction;

              // Create a path object
              final path = Path();

              // Iterate over the line segment and draw dashes
              for (double distance = 0.0;
                  distance < lineLength;
                  distance += dashLength + gapLength) {
                final start =
                    startPoint + Offset.fromDirection(lineDirection, distance);
                final end =
                    start + Offset.fromDirection(lineDirection, dashLength);
                path.moveTo(start.dx, start.dy);
                path.lineTo(end.dx, end.dy);

                canvas.drawPath(path, linePaint);
              }

              // Draw the dashed line using the path and paint objects
            }
             if(!(beatsLines![i]['p1'] == Offset.zero && beatsLines![i]['p2'] ==Offset.zero)){
                drawIconAtEnd(
                canvas, beatsLines![i]['p2'], beatsLines![i]['color']);
            }
          }
        }
      } else {
        null;
      }
    }

    // Draw the user-drawn line
    if (startPoint != Offset.zero &&
        endPoint != Offset.zero &&
        isShowStatics != true) {
      Paint linePaint = Paint()
        ..color = transparent != null
            ? Colors.transparent
            : Colors.black // Change the line color as needed
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2; // Change the line thickness as needed

      // Define the length of each dash and gap in the dashed line
      const dashLength = 5.0;
              const gapLength = 2;

      // Calculate the length and direction of the line segment
      final lineLength = (endPoint - startPoint).distance;
      final lineDirection = (endPoint - startPoint).direction;

      // Create a path object
      final path = Path();

      // Iterate over the line segment and draw dashes
      for (double distance = 0.0;
          distance < lineLength;
          distance += dashLength + gapLength) {
        final start =
            startPoint + Offset.fromDirection(lineDirection, distance);
        final end = start + Offset.fromDirection(lineDirection, dashLength);
        path.moveTo(start.dx, start.dy);
        path.lineTo(end.dx, end.dy);
        final BallLineCubit ballLincecubit =
            BlocProvider.of<BallLineCubit>(context);
        ballLincecubit.endPoint == endPoint &&
                ballLincecubit.startPoint == startPoint
            ? null
            : ballLincecubit.newLine(
                startPoint,
                endPoint,
                false,
              );
      }

      // Draw the dashed line using the path and paint objects
      canvas.drawPath(path, linePaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class FieldWithBorderPainter extends CustomPainter {
  final double fieldWidth;
  final double fieldHeight;
  final Offset startPoint;
  final Offset endPoint;
  final bool? transparent;
  final BuildContext context;
  final double borderMargin;
  final bool? isShowStatics;
  final List? beatsLines;

  FieldWithBorderPainter({
    required this.fieldWidth,
    required this.fieldHeight,
    required this.startPoint,
    required this.endPoint,
    this.beatsLines,
    this.transparent,
    required this.context,
    this.borderMargin = 20.0, // Set the margin value
    required this.isShowStatics,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white // Change the color as needed
      ..style = PaintingStyle.fill;

    // Calculate the actual field dimensions with the margin
    final double actualFieldWidth = fieldWidth - 2 * borderMargin;
    final double actualFieldHeight = fieldHeight - 2 * borderMargin;
    final double fieldX = borderMargin;
    final double fieldY = borderMargin;

    // Draw the border
    canvas.drawRect(
      Rect.fromLTRB(0, 0, fieldWidth, fieldHeight),
      Paint()
        ..color = Colors.grey // Set the border color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4, // Set the border thickness
    );

    // Draw the volleyball field
    canvas.drawRect(
      Rect.fromLTRB(fieldX, fieldY, fieldX + actualFieldWidth,
          fieldY + actualFieldHeight),
      paint,
    );

    // Draw the wall line in the middle

    // Draw horizontal lines (4 lines)
    final sectionHeight = actualFieldHeight / 5;
    for (int i = 0; i <= 5; i++) {
      final yOffset = fieldY + i * sectionHeight;
      canvas.drawLine(
        Offset(fieldX, yOffset),
        Offset(fieldX + actualFieldWidth, yOffset),
        Paint()
          ..color = Colors.blueAccent // Change the color as needed
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1, // Change the line thickness as needed
      );
    }

    // Draw vertical lines (9 lines)
    final sectionWidth = actualFieldWidth / 8;
    for (int i = 0; i < 9; i++) {
      final xOffset = fieldX + i * sectionWidth;
      canvas.drawLine(
        Offset(xOffset, fieldY),
        Offset(xOffset, fieldY + actualFieldHeight),
        Paint()
          ..color = i == 4
              ? Colors.blue[900]!
              : Colors.blueAccent // Change the color as needed
          ..style = PaintingStyle.stroke
          ..strokeWidth = i == 4 ? 2 : 1, // Change the line thickness as needed
      );
    }

    if (isShowStatics == true) {
      if (beatsLines != null) {
        for (int i = 0; beatsLines!.length > i; i++) {
          if (beatsLines![i]['continued']) {
            canvas.drawLine(
              beatsLines![i]['p1'],
              beatsLines![i]['p2'],

              Paint()
                ..color =
                    beatsLines![i]['color'] // Change the line color as needed
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2, // Change the line thickness as needed
            );

            // Draw an icon at the midpoint
            // Draw an icon at the end of the line
             if(!(beatsLines![i]['p1'] == Offset.zero && beatsLines![i]['p2'] ==Offset.zero)){
                drawIconAtEnd(
                canvas, beatsLines![i]['p2'], beatsLines![i]['color']);
            }
          } else {
            Offset startPoint = beatsLines![i]['p1'];
            Offset endPoint = beatsLines![i]['p2'];
            if (startPoint != null && endPoint != null) {
              Paint linePaint = Paint()
                ..color =
                    beatsLines![i]['color'] // Change the line color as needed
                ..style = PaintingStyle.stroke
                ..strokeWidth = 2;

              // Define the length of each dash and gap in the dashed line
              const dashLength = 5.0;
              const gapLength = 2;

              // Calculate the length and direction of the line segment
              final lineLength = (endPoint - startPoint).distance;
              final lineDirection = (endPoint - startPoint).direction;

              // Create a path object
              final path = Path();
              // Iterate over the line segment and draw dashes
              for (double distance = 0.0;
                  distance < lineLength;
                  distance += dashLength + gapLength) {
                final start =
                    startPoint + Offset.fromDirection(lineDirection, distance);
                final end =
                    start + Offset.fromDirection(lineDirection, dashLength);
                path.moveTo(start.dx, start.dy);
                path.lineTo(end.dx, end.dy);

                canvas.drawPath(path, linePaint);
                 
              }

              // Draw the dashed line using the path and paint objects
            }
             if(!(beatsLines![i]['p1'] == Offset.zero && beatsLines![i]['p2'] ==Offset.zero)){
                drawIconAtEnd(
                canvas, beatsLines![i]['p2'], beatsLines![i]['color']);
            }
          }
        }
      }
    }

    // Draw the user-drawn line
    if (startPoint != Offset.zero &&
        endPoint != Offset.zero &&
        isShowStatics != true) {
      //inverse this line horizontaly
      canvas.drawLine(
        startPoint,
        endPoint,
        Paint()
          ..color = transparent != null
              ? Colors.transparent
              : Colors.black // Change the line color as needed
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2, // Change the line thickness as needed
      );
      final BallLineCubit ballLincecubit =
          BlocProvider.of<BallLineCubit>(context);
      ballLincecubit.endPoint == endPoint &&
              ballLincecubit.startPoint == startPoint
          ? null
          : ballLincecubit.newLine(
              startPoint,
              endPoint,
              true,
            );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

void drawIconAtEnd(Canvas canvas, Offset end, Color color) {
  // Replace 'Icons.add' with the desired icon
  // You can customize the size and color of the icon as needed
  Icon icon = Icon(
    Icons.circle,
    color: color, // Change the icon color as needed
    size: 10, // Change the icon size as needed
  );

  // Create a TextPainter for rendering the icon

  // Create a TextPainter for rendering the icon
  TextPainter textPainter = TextPainter(
    text: TextSpan(
      text: String.fromCharCode(icon.icon!.codePoint),
      style: TextStyle(
        fontFamily: icon.icon!.fontFamily,
        fontSize: icon.size,
        color: icon.color,
      ),
    ),
    textDirection: TextDirection.ltr,
  );

  // Layout the TextPainter to get the dimensions
  textPainter.layout();

  // Adjust the position to bring the icon closer to the start of the line
  double offsetX =
      -textPainter.width / 2; // Adjust this value to bring it closer or farther

  // Draw the icon at the adjusted position
  textPainter.paint(canvas, end.translate(offsetX, -textPainter.height / 2));
}
