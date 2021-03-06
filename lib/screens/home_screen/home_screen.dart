import 'package:auto_size_text/auto_size_text.dart';
import 'package:fast_tech_app/const/assets_const.dart';
import 'package:fast_tech_app/const/color_conts.dart';
import 'package:fast_tech_app/core/provider/cart_provider.dart';
import 'package:fast_tech_app/helper/navigation_helper.dart';
import 'package:fast_tech_app/helper/token_helper.dart';
import 'package:fast_tech_app/screens/choose_language_screen/choose_language_screen.dart';
import 'package:fast_tech_app/screens/home_screen/home_screen_components/cart_screen_dashborad_component.dart';
import 'package:fast_tech_app/screens/home_screen/home_screen_components/home_screen_dashboard_components.dart';
import 'package:fast_tech_app/screens/home_screen/home_screen_components/user_screen_dashboard_component.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

enum DASBOARD_ENUM { homeScreen, cart, user }

class HomeScreen extends StatefulWidget {
  final DASBOARD_ENUM dasboardEnum;
  const HomeScreen({Key? key, required this.dasboardEnum}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color _backgroundColor = const Color(0xffFAF9FE);
  late Size _size;

  late DASBOARD_ENUM dashboardEnum;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dashboardEnum = widget.dasboardEnum;
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _homeScreenWidget(),
    );
  }

  Widget _homeScreenWidget() {
    Widget _dashboard = Container();
    switch (dashboardEnum) {
      case DASBOARD_ENUM.homeScreen:
        _dashboard = const HomeScreenDashboardComponents();
        break;
      case DASBOARD_ENUM.cart:
        _dashboard = const CartScreenDashboardComponent();
        break;
      case DASBOARD_ENUM.user:
        _dashboard = const UserScreenDashboardComponent();
        break;

      default:
    }

    return Stack(
      children: [
        Container(
          color: _backgroundColor,
          width: _size.width,
          height: _size.height,
          child: Column(
            children: [
              const SizedBox(height: 30),
              _headerWidget(),
              const SizedBox(height: 5),
              _dashboard,
            ],
          ),
        ),
        _navigationBarWidget(),
      ],
    );
  }

  Widget _navigationBarWidget() {
    return Positioned(
      bottom: 0,
      width: _size.width,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(.2)),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(1000),
            topRight: Radius.circular(1000),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 15, top: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavigationButton(DASBOARD_ENUM.user),
              Center(
                child: Column(
                  children: [
                    _buildNavigationButton(DASBOARD_ENUM.homeScreen),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Stack(
                children: [
                  Positioned(
                    right: 15,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                      child: Text(
                        Provider.of<CartModelProvider>(context).cartModelList.length.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  _buildNavigationButton(DASBOARD_ENUM.cart),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(DASBOARD_ENUM dasboardEnum) {
    Widget icon = Container();

    IconData iconData = Icons.home;

    switch (dasboardEnum) {
      case DASBOARD_ENUM.cart:
        iconData = Icons.shopping_cart;
        break;
      case DASBOARD_ENUM.user:
        iconData = Icons.person;
        break;
      default:
    }

    icon = AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: 50,
        height: 50,
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: dashboardEnum == dasboardEnum ? ColorsConts.primaryColor : Colors.transparent, width: 2)),
        child: Icon(
          iconData,
          size: 30,
          color: dashboardEnum == dasboardEnum ? ColorsConts.primaryColor : Colors.black,
        ));

    return InkWell(
        onTap: () {
          setState(() {
            dashboardEnum = dasboardEnum;
          });
        },
        child: icon);
  }

  Widget _headerWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20),
      child: Row(
        children: [
          _buildChangeLanguageButton(),
          const SizedBox(width: 20),
          _buildCompanyLabel(),
        ],
      ),
    );
  }

  Widget _buildChangeLanguageButton() {
    return Container(
      width: 100,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorsConts.primaryColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: (() => NavigationHelper.push(
                context,
                const ChooseLanguageScreen(
                  hasContext: true,
                ))),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  width: 50,
                  height: 40,
                  child: Image.asset(TokenHelper.getInstance().getLanguageCode == "km" ? AssetsConst.CAMBODAI_FLAG : AssetsConst.UNITEDK_INDOM_FLAG),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: const Icon(
                    FontAwesomeIcons.sort,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyLabel() {
    return const Expanded(
      child: Center(
        child: AutoSizeText(
          'FAST TECHNOLOGIES',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          maxLines: 1,
        ),
      ),
    );
  }
}
