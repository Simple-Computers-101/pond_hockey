import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pond_hockey/components/appbar/appbar.dart';
import 'package:pond_hockey/components/dialog/dialog_buttons.dart';
import 'package:pond_hockey/components/loading/loading.dart';
import 'package:pond_hockey/enums/viewing_mode.dart';
import 'package:pond_hockey/models/user.dart';
import 'package:pond_hockey/router/router.gr.dart';
import 'package:pond_hockey/screens/tournaments/widgets/buy_credits_sheet.dart';
import 'package:pond_hockey/screens/tournaments/widgets/tournament_viewing.dart';
import 'package:pond_hockey/screens/tournaments/widgets/tournaments_list.dart';
import 'package:pond_hockey/services/databases/tournaments_repository.dart';
import 'package:pond_hockey/services/databases/user_repository.dart';
import 'package:pond_hockey/services/iap_helper.dart';

class TournamentsScreen extends StatelessWidget {
  final repo = TournamentsRepository();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var mode = TournamentViewing.of(context).mode;

    bool canEditOrScore() {
      return mode == ViewingMode.editing || mode == ViewingMode.scoring;
    }

    bool canEdit() {
      return mode == ViewingMode.editing;
    }

    bool isScoring() {
      return mode == ViewingMode.scoring;
    }

    Widget buildLoading() {
      return LoadingScreen();
    }

    Widget buildError(Object error) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Uh oh!',
            style: Theme.of(context).textTheme.headline2,
          ),
          Text(error.toString()),
        ],
      );
    }

    Widget buildAllTournaments() {
      return StreamBuilder<QuerySnapshot>(
        stream: repo.ref.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return buildLoading();
          } else if (snapshot.hasError) {
            return buildError(snapshot.error);
          }
          return Visibility(
            visible: snapshot.data.documents.isNotEmpty,
            child: TournamentsList(
              documents: snapshot.data.documents,
            ),
            replacement: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'There are no tournaments!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  'Check back later.',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          );
        },
      );
    }

    void _showBillingUnavailableDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Billing Unavailable'),
            content: Text(
              '''Unfortunately billing is not available at this time.\n\nTry again later.''',
            ),
            actions: <Widget>[
              PrimaryDialogButton(
                onPressed: Router.navigator.pop,
                text: 'Okay',
              ),
            ],
          );
        },
      );
    }

    Future<void> _checkCanPurchase() async {
      final canPurchase = await IAPHelper().initialize();
      if (canPurchase) {
        showModalBottomSheet(
          context: context,
          builder: (context) => BuyCreditsSheet(),
          enableDrag: false,
          isScrollControlled: false,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15),
            ),
          ),
        );
      } else {
        _showBillingUnavailableDialog();
      }
    }

    void _showInsufficientCreditsDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Insufficient credits'),
            content: Text(
              '''You need more credits in order to create a tournament.\n\nWould you like to buy more?''',
            ),
            actions: <Widget>[
              SecondaryDialogButton(
                text: 'No',
                onPressed: Router.navigator.pop,
              ),
              PrimaryDialogButton(
                text: 'Buy more',
                onPressed: () {
                  // close dialog
                  Router.navigator.pop();
                  _checkCanPurchase();
                },
              ),
            ],
          );
        },
      );
    }

    return FutureBuilder<User>(
      future: UserRepository().getCurrentUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !canEditOrScore()) {
          return Scaffold(
            appBar: CustomAppBar(title: 'Tournaments'),
            body: SingleChildScrollView(child: buildAllTournaments()),
          );
        }
        final user = snapshot.data;
        return Scaffold(
          key: scaffoldKey,
          appBar: CustomAppBar(
            title: canEdit()
                ? 'Manage Tournaments'
                : isScoring() ? 'Score Tournaments' : 'Error',
          ),
          floatingActionButton: canEdit()
              ? FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    if (user.credits == 0) {
                      _showInsufficientCreditsDialog();
                    } else {
                      Router.navigator.pushNamed(Routes.addTournament);
                    }
                  },
                )
              : null,
          body: ManageableTournamentsList(user: user, editor: canEdit()),
        );
      },
    );
  }
}

class ManageableTournamentsList extends StatelessWidget {
  const ManageableTournamentsList({
    @required this.user,
    this.editor = false,
  });

  final User user;
  final bool editor;

  @override
  Widget build(BuildContext context) {
    final repo = TournamentsRepository();
    return FutureBuilder(
      future: editor
          ? repo.getEditableTournaments(user.uid)
          : repo.getScorerTournaments(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return LoadingScreen();
        } else if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data.isNotEmpty) {
            return ListView(
              children: <Widget>[
                Text('Credits: ${user.credits}'),
                TournamentsList(documents: snapshot.data),
              ],
            );
          } else {
            return ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              primary: false,
              children: <Widget>[
                if (editor) CreditsAmount(credits: user.credits),
                SvgPicture.asset(
                  'assets/svg/no_data.svg',
                  height:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.height * 0.25
                          : MediaQuery.of(context).size.width * 0.25,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Text(
                  'You don\'t have any tournaments!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        fontFamily: 'CircularStd',
                      ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Text(
                  editor
                      ? 'Create some or be invited to one.'
                      : 'You must be invited to one.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Color(0xFF747474),
                        fontFamily: 'CircularStd',
                      ),
                ),
              ],
            );
          }
        }
        return SizedBox();
      },
    );
  }
}

class CreditsAmount extends StatelessWidget {
  const CreditsAmount({@required this.credits});

  final int credits;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.topRight,
      child: Column(
        children: <Widget>[
          Text(
            'Credits',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: Color(0xFF747474), fontFamily: 'CircularStd'),
          ),
          Text(
            '$credits',
            style: Theme.of(context)
                .textTheme
                .headline4
                .copyWith(color: Colors.black, fontFamily: 'CircularStd'),
          ),
        ],
      ),
    );
  }
}
