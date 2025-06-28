import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/route/auth_guard.dart';

@AutoRouterConfig(generateForDir: ['lib/presentation'])
class AppRouter extends RootStackRouter {
  final AuthGuard authGuard;

  AppRouter({
    required this.authGuard,
  });

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/launch',
          page: LaunchRoute.page,
        ),
        AutoRoute(
          path: '/welcome',
          page: WelcomeRoute.page,
        ),
        AutoRoute(
          path: '/profile/register',
          page: ProfileRoute.page,
        ),
        AutoRoute(
          path: '/sign_up',
          page: SignUpRoute.page,
        ),
        AutoRoute(
          path: '/sign_up_creator',
          page: SignUpCreatorRoute.page,
        ),
        AutoRoute(
          path: '/log_in',
          page: LogInRoute.page,
        ),
        AutoRoute(
          path: '/phone_auth',
          page: PhoneAuthRoute.page,
        ),
        AutoRoute(
          path: '/migrate_auth',
          page: MigrateAuthRoute.page,
        ),
        AutoRoute(
          path: '/migrate_auth/confirm',
          page: MigrateConfirmRoute.page,
        ),
        AutoRoute(
          path: '/send_password_reset',
          page: SendPasswordResetRoute.page,
        ),
        CustomRoute(
          path: '/auth_sheet',
          page: AuthSheetRoute.page,
          customRouteBuilder: modalSheetBuilder,
          children: [
            AutoRoute(
              path: 'phone',
              page: PhoneAuthRoute.page,
              meta: const {
                RouteMetaKey.isChildrenRoute: true,
              },
            ),
          ],
        ),
        AutoRoute(
          path: '/walkthrough',
          page: WalkthroughRoute.page,
          fullscreenDialog: true,
        ),
        RedirectRoute(
          path: '/walkthrough',
          redirectTo: '/home',
        ),
        AutoRoute(
          path: '/',
          page: HomeRoute.page,
          guards: [welcomeGuard],
          children: [
            AutoRoute(
              path: 'timeline',
              page: TimelineRoute.page,
              meta: const {
                RouteMetaKey.isChildrenRoute: true,
              },
            ),
            AutoRoute(
              path: 'creator_media',
              page: CreatorMediaRoute.page,
              meta: const {
                RouteMetaKey.isChildrenRoute: true,
              },
            ),
            AutoRoute(
              path: 'media/top',
              page: MediaTopRoute.page,
              meta: const {
                RouteMetaKey.isChildrenRoute: true,
              },
            ),
            AutoRoute(
              path: 'media',
              page: MediaRoute.page,
              meta: const {
                RouteMetaKey.isChildrenRoute: true,
              },
            ),
            // AutoRoute(
            //   path: 'communities',
            //   page: CommunitiesRoute.page,
            //   meta: const {
            //     RouteMetaKey.isChildrenRoute: true,
            //   },
            // ),
            AutoRoute(
              path: 'communities_list',
              page: CommunitiesListRoute.page,
              meta: const {
                RouteMetaKey.isChildrenRoute: true,
              },
            ),
            AutoRoute(
              path: 'rooms_tab',
              page: RoomRoute.page,
              meta: const {
                RouteMetaKey.isChildrenRoute: true,
              },
            ),
            AutoRoute(
              path: 'announcements_tab',
              page: AnnouncementsRoute.page,
              meta: const {
                RouteMetaKey.isChildrenRoute: true,
              },
            ),
            AutoRoute(
              path: 'shop',
              page: ShopRoute.page,
              meta: const {
                RouteMetaKey.isChildrenRoute: true,
              },
            ),
            AutoRoute(
              path: 'web_shop',
              page: WebShopRoute.page,
              meta: const {
                RouteMetaKey.isChildrenRoute: true,
              },
            ),
            AutoRoute(
              path: 'my_page_tab',
              page: MypageRoute.page,
              meta: const {
                RouteMetaKey.isChildrenRoute: true,
              },
            ),
            AutoRoute(
              path: 'ranking',
              page: RankingRoute.page,
              meta: const {
                RouteMetaKey.isChildrenRoute: true,
              },
            ),
            AutoRoute(
              path: 'rankers',
              page: RankersRoute.page,
              meta: const {
                RouteMetaKey.isChildrenRoute: true,
              },
            ),
            AutoRoute(
              path: 'scratches_tab',
              page: ScratchesRoute.page,
              meta: const {
                RouteMetaKey.isChildrenRoute: true,
              },
            ),
            AutoRoute(
              path: 'scratches_tab/:id',
              page: ScratchRoute.page,
              meta: const {
                RouteMetaKey.isChildrenRoute: true,
              },
            ),
            AutoRoute(
              path: 'program',
              page: ProgramRoute.page,
              meta: const {
                RouteMetaKey.isChildrenRoute: true,
              },
            ),
            AutoRoute(
              path: 'recruitments',
              page: RecruitmentsTopRoute.page,
              meta: const {
                RouteMetaKey.isChildrenRoute: true,
              },
            ),
            AutoRoute(
              path: 'chat_list',
              page: ChatListRoute.page,
              meta: const {
                RouteMetaKey.isChildrenRoute: true,
              },
            ),
          ],
        ),
        AutoRoute(
          path: '/recruitments/new',
          page: CreateRecruitmentsRoute.page,
        ),
        AutoRoute(
          path: '/media/playlists/:id',
          page: MediaPlaylistRoute.page,
          meta: const {
            RouteMetaKey.isChildrenRoute: true,
          },
        ),
        AutoRoute(
          path: '/media/:id/edit',
          page: MediaUploadRoute.page,
        ),
        AutoRoute(
          path: '/reels/:id/edit',
          page: ReelUploadRoute.page,
        ),
        AutoRoute(
          path: '/media/:id',
          page: MediumRoute.page,
        ),
        RedirectRoute(
          path: '/video/:id',
          redirectTo: '/media/:id',
        ),
        AutoRoute(
          path: '/announcements',
          page: AnnouncementsRoute.page,
        ),
        AutoRoute(
          path: '/announcements/:id',
          page: AnnouncementRoute.page,
        ),
        AutoRoute(
          path: '/announcements/:id/edit',
          page: AnnouncementEditRoute.page,
        ),
        AutoRoute(
          path: '/community/-',
          page: CommunitySearchRoute.page,
        ),
        AutoRoute(
          path: '/community/:id',
          page: CommunityRoute.page,
        ),
        CustomRoute(
          path: '/community_edit/:id',
          page: CommunityEditRoute.page,
          customRouteBuilder: modalSheetBuilder,
        ),
        AutoRoute(
          path: '/creator/:id',
          page: CreatorRoute.page,
        ),
        AutoRoute(
          path: '/chat/:id',
          page: ChatRoomRoute.page,
        ),
        AutoRoute(
          path: '/chat_template',
          page: ChatTemplateRoute.page,
        ),
        AutoRoute(
          path: '/playground',
          page: PlaygroundRoute.page,
        ),
        AutoRoute(
          guards: [authGuard],
          path: '/notification_setting',
          page: NotificationSettingRoute.page,
        ),
        AutoRoute(
          guards: [authGuard],
          path: '/notification_setting/:creatorId',
          page: UserNotificationSettingRoute.page,
        ),
        AutoRoute(
          path: '/stories/:initialStoryId',
          page: StoryRoute.page,
        ),
        AutoRoute(
          path: '/reels/:initialReelId',
          page: ReelRoute.page,
        ),
        // AutoRoute(
        //   path: '/story/-/preview',
        //   page: StoryCreatePreviewRoute.page,
        // ),
        CustomRoute(
          path: '/story/-/preview',
          page: StoryCreatePreviewRoute.page,
          transitionsBuilder: TransitionsBuilders.noTransition,
        ),
        AutoRoute(
          path: '/my_page',
          page: MypageRoute.page,
        ),
        AutoRoute(
          path: '/my_page/membership',
          page: MypageMembershipRoute.page,
        ),
        AutoRoute(
          path: '/live/-',
          page: LiveStreamRoute.page,
        ),
        CustomRoute(
          path: '/lives/:liveId/finished',
          page: LiveStreamResultRoute.page,
          fullMatch: true,
          opaque: false,
          barrierColor: Colors.transparent,
          fullscreenDialog: true,
        ),
        CustomRoute(
          path: '/lives/:liveId',
          page: LivePlayerRoute.page,
          customRouteBuilder: modalSheetBuilder,
        ),
        AutoRoute(
          path: '/tencent_lives/:liveId',
          page: TencentLivePlayerRoute.page,
        ),
        AutoRoute(
          path: '/tencet_live',
          page: TencentStreamRoute.page,
        ),
        AutoRoute(
          path: '/articles/:id',
          page: ArticleRoute.page,
        ),
        AutoRoute(
          path: '/article_create',
          page: ArticleCreateRoute.page,
        ),
        AutoRoute(
          path: '/article_create/drafts',
          page: ArticleDraftsRoute.page,
        ),
        CustomRoute(
          path: '/article_vote_result/:articleId',
          page: ArticleVoteResultRoute.page,
          customRouteBuilder: modalSheetBuilder,
        ),
        CustomRoute(
          path: '/select_medium',
          page: SelectMediumRoute.page,
          customRouteBuilder: modalSheetBuilder,
        ),
        AutoRoute(
          path: '/select_reel_medium',
          page: SelectReelMediumRoute.page,
        ),
        AutoRoute(
          path: '/rankers/:id',
          page: RankerRoute.page,
        ),
        AutoRoute(
          path: '/reset_password',
          page: ResetPasswordRoute.page,
        ),
        // AutoRoute<AppMessageButton?>(
        //   path: '/maintenance',
        //   page: MaintenanceRoute.page,
        //   fullscreenDialog: true,
        // ),
        AutoRoute(
          path: '/rankers/:id/matches',
          page: RankerMatchesCombatExperienceListRoute.page,
        ),
        AutoRoute(
          path: '/rooms',
          page: RoomRoute.page,
        ),
        AutoRoute(
          path: '/rooms/:roomId',
          page: RoomMessagesRoute.page,
        ),
        AutoRoute(
          path: '/web_view/:url',
          page: WebViewRoute.page,
        ),
        AutoRoute(
          path: '/profile',
          page: MemberProfileRoute.page,
        ),
        AutoRoute(
          guards: [authGuard],
          path: '/edit_profile',
          page: ProfileEditRoute.page,
        ),
        CustomRoute(
          path: '/plans',
          page: PlanListRoute.page,
          customRouteBuilder: modalSheetBuilder,
        ),
        AutoRoute(
          path: '/membership/leave',
          page: LeaveMembershipRoute.page,
        ),
        CustomRoute(
          path: '/media/:id',
          page: MediumRoute.page,
          customRouteBuilder: modalSheetBuilder,
        ),
        CustomRoute(
          path: '/playlist_create',
          page: PlaylistCreateRoute.page,
          customRouteBuilder: modalSheetBuilder,
        ),
        CustomRoute(
          path: '/playlist_edit/:id',
          page: PlaylistEditRoute.page,
          customRouteBuilder: modalSheetBuilder,
        ),
        CustomRoute(
          path: '/playlist_add_media',
          page: PlaylistAddMediaRoute.page,
          customRouteBuilder: modalSheetBuilder,
        ),
        AutoRoute(
          path: '/playlist/:id',
          page: PlaylistDetailRoute.page,
        ),
        CustomRoute(
          path: '/events/:id',
          page: FestaDetailRoute.page,
          fullscreenDialog: true,
          transitionsBuilder: AppTransitionsBuilders.slideBottomEaseOut,
        ),
        RedirectRoute(
          path: '/communities',
          redirectTo: '/communities_list',
        ),
        AutoRoute(
          path: '/scratches/:id',
          page: ScratchRoute.page,
        ),
        RedirectRoute(
          path: '/scratch/:id',
          redirectTo: '/scratches/:id',
        ),
        AutoRoute(
          path: '/scratches/:id/rate',
          page: ScratchRateRoute.page,
        ),
        RedirectRoute(
          path: '/scratch/:id/rate',
          redirectTo: '/scratches/:id/rate',
        ),
        RedirectRoute(
          path: '/scratches',
          redirectTo: '/scratches_tab',
        ),
        AutoRoute(
          guards: [authGuard],
          path: '/me/account',
          page: MypageAccountRoute.page,
        ),
        AutoRoute(
          path: '/me/edit',
          page: MypageEditRoute.page,
        ),
        AutoRoute(
          path: '/me/push_settings',
          page: MypagePushSettingRoute.page,
        ),
        AutoRoute(
          path: '/me/products',
          page: MyProductsRoute.page,
        ),
        AutoRoute(
          path: '/me/products/:id',
          page: MyProductRoute.page,
        ),
        CustomRoute(
          path: '/me/verified_identity',
          page: IdentityVerificationRoute.page,
          fullscreenDialog: true,
          transitionsBuilder: AppTransitionsBuilders.slideBottomEaseOut,
        ),
        CustomRoute(
          path: '/me/verify',
          page: InputIdentifyRoute.page,
          fullscreenDialog: true,
          transitionsBuilder: AppTransitionsBuilders.slideBottomEaseOut,
        ),
        AutoRoute(
          path: '/me/verify/wait',
          page: WaitEkycRoute.page,
        ),
        AutoRoute(
          path: '/me/verify/fail',
          page: EkycFailureRoute.page,
        ),
        CustomRoute(
          path: '/me/achievements/clip',
          page: ClipAchievementsRoute.page,
          customRouteBuilder: createModalBottomSheetBuilder(
            isScrollControlled: true,
            isDismissible: false,
            enableDrag: false,
          ),
        ),
        AutoRoute(
          guards: [authGuard],
          path: '/user_address',
          page: UserAddressRoute.page,
        ),
        AutoRoute(
          path: '/user_achievements/:user_id',
          page: UserAchievementsRoute.page,
        ),
        AutoRoute(
          path: '/user_profile/:id',
          page: UserProfileRoute.page,
        ),
        RedirectRoute(
          path: '/home',
          redirectTo: '/',
        ),
      ];
}

Route<T> modalSheetBuilder<T>(
  BuildContext context,
  Widget child,
  AutoRoutePage<T> page,
) {
  bool enableDrag() {
    return page.name != 'LiveSheetRoute';
  }

  // TODO: Replace with builtin one if flutter update to 3.7 or above.
  return ModalBottomSheetRoute(
    settings: page,
    builder: (context) {
      // HACK: https://github.com/flutter/flutter/pull/121588
      final query = MediaQuery.of(context);
      final originalQuery = MediaQueryData.fromView(
        View.of(context),
      );

      return MediaQuery(
        data: query.copyWith(padding: originalQuery.padding),
        child: child,
      );
    },
    // NOTE: useSafeArea: true を使うと
    //       Android 画面上部のステータスバーの背景色が濃くなり、以前と異なる挙動になる。
    // useSafeArea: true,
    // expanded: false,
    // duration: const Duration(milliseconds: 250),
    // animationCurve: Curves.easeInOut,
    enableDrag: enableDrag(),
    isScrollControlled: true,
  );
}

CustomRouteBuilder createModalBottomSheetBuilder({
  required bool isScrollControlled,
  bool enableDrag = true,
  bool expanded = false,
  bool isDismissible = true,
}) {
  Route<T> buildModalBottomSheet<T>(
    BuildContext context,
    Widget child,
    AutoRoutePage<T> page,
  ) {
    return ModalBottomSheetRoute(
      settings: page,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return child;
      },
    );
  }

  return buildModalBottomSheet;
}
