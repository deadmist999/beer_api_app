import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:beer_api_app/bloc/beer_bloc.dart';
import 'package:beer_api_app/ui/widgets/beer_card.dart';
import 'package:beer_api_app/ui/widgets/loading_widget.dart';

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({Key? key}) : super(key: key);

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  late BeerBloc beerBloc;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    controller.addListener(() => onScroll());
    beerBloc = context.read<BeerBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BeerBloc, BeerState>(
        bloc: beerBloc,
        builder: (context, state) {
          if (state is BeerInitial) {
            return LoadingIndicator();
          }
          if (state is BeerLoaded) {
            if (state.beers.isEmpty) {
              return Center(child: Text('No beer'));
            }
            return ListView.builder(
                controller: controller,
                itemCount: state.beers.length + 1,
                itemBuilder: (context, index) {
                  if (index >= state.beers.length)
                    return LinearProgressIndicator();
                  return BeerCard(beer: state.beers[index]);
                });
          } else {
            return Text('Error');
          }
        });
  }

  @override
  void dispose() {
    controller.removeListener(() => onScroll);
    super.dispose();
  }

  void onScroll() {
    final maxScroll = controller.position.maxScrollExtent;
    final currentScroll = controller.position.pixels;
    if (currentScroll == maxScroll) {
      beerBloc.add(BeerFetched());
    }
  }
}
