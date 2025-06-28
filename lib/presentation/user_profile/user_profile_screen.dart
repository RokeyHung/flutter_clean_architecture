import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/utils/extension/hook_ext.dart';
import 'package:flutter_clean_architecture/presentation/user_profile/models/user_profile_data_model.dart';
import 'package:flutter_clean_architecture/presentation/user_profile/user_profile_controller.dart';
import 'package:flutter_clean_architecture/presentation/user_profile/user_profile_presenter.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

@RoutePage()
class UserProfileScreen extends HookConsumerWidget {
  const UserProfileScreen({
    super.key,
    @PathParam('id') required this.userId,
  });

  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = userProfilePresenter(userId);
    final presenter = ref.watch(viewModelProvider.notifier);
    final viewModel = ref.watch(viewModelProvider);
    final controller = ref.watch(userProfileControllerProvider(presenter));

    useOnInitialize(() async {
      await controller.load(userId);
    });

    useOnReceive<UserProfileAction>(presenter.actions, (event) {
      event.when(
        failedToLoad: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('読み込みに失敗しました。')),
          );

          context.router.maybePop();
        },
      );
    });

    return Scaffold(
      appBar: OEMAppBar(
        title: Text(
          'プロフィール',
          style: oemTheme.textTheme.p16.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: AppIconButton(
          icon: Assets.icon.xmark,
          iconSize: const Size(24, 24),
          color: context.oemTheme.colorScheme.defaultt.white,
          onTap: () {
            context.router.maybePop();
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.load(userId);
        },
        child: CustomScrollView(
          clipBehavior: Clip.none,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildIntroductionField(context, viewModel),
            if (viewModel.subImages.isNotEmpty)
              _buildImageSection(context, viewModel.subImages),
            if (viewModel.userRecruitments.isNotEmpty)
              _buildRecruitments(context, viewModel, controller),
          ],
        ),
      ),
    );
  }

  SliverList _buildIntroductionField(
    BuildContext context,
    UserProfileDataModel viewModel,
  ) {
    final oemTheme = context.oemTheme;

    Widget socialLink({
      required SvgGenImage icon,
      required String accountName,
      required void Function() onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            AppIcon(
              icon: icon,
              iconSize: _kIconSize,
              color: oemTheme.colorScheme.label.secondary,
            ),
            const Gap(2),
            Text(
              accountName,
              style: oemTheme.textTheme.p12.copyWith(
                fontWeight: FontWeight.w400,
                color: oemTheme.colorScheme.label.secondary,
              ),
            ),
          ],
        ),
      );
    }

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const Gap(12),
          Container(
            decoration: BoxDecoration(
              color: oemTheme.colorScheme.background.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await ImageViewScreen.show(
                            context,
                            url: viewModel.imageUrl,
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            _kProfileImageSize / 2,
                          ),
                          child: AppSizedImage(
                            imageUrl: viewModel.imageUrl,
                            width: _kProfileImageSize,
                            height: _kProfileImageSize,
                          ),
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  viewModel.name,
                                  style: oemTheme.textTheme.p20.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: oemTheme.colorScheme.label.primary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Visibility(
                                  visible: viewModel.isVerified,
                                  child: Assets.icon.acheckmarkShieldFill
                                      .svg(height: 18, width: 18),
                                ),
                              ],
                            ),
                            Text(
                              _genderAgeText(
                                  ageRange: viewModel.ageRange,
                                  gender: viewModel.gender),
                              style: oemTheme.textTheme.p12.copyWith(
                                fontWeight: FontWeight.w400,
                                color: oemTheme.colorScheme.label.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    viewModel.description,
                    style: oemTheme.textTheme.p13.copyWith(
                      fontWeight: FontWeight.w400,
                      color: oemTheme.colorScheme.label.primary,
                    ),
                  ),
                  const Gap(8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      socialLink(
                        icon: AppAssets.icon.social.instagram,
                        accountName: _getUserLinkUserName(
                                viewModel.userLinks, 'instagram') ??
                            '未設定',
                        onTap: () {
                          // TODO: instagramの処理
                        },
                      ),
                      const Gap(8),
                      Container(
                        width: 0.5,
                        height: 12,
                        color: oemTheme.colorScheme.label.tertiary,
                      ),
                      const Gap(8),
                      socialLink(
                        icon: AppAssets.icon.social.twitter,
                        accountName: _getUserLinkUserName(
                                viewModel.userLinks, 'twitter') ??
                            '未設定',
                        onTap: () {
                          // TODO: Twitterの処理
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverList _buildImageSection(BuildContext context, List<SubImage> subImage) {
    return SliverList(
      delegate: SliverChildListDelegate([
        const Gap(20),
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: _kUserImageSize,
            maxWidth: _kUserImageSize,
          ),
          child: ListView.separated(
            itemCount: subImage.length,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => InkWell(
              onTap: () async {
                await ImageViewScreen.show(
                  context,
                  url: subImage[index].imageUrl,
                );
              },
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                child: AppSizedImage(
                  imageUrl: subImage[index].imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            separatorBuilder: (context, index) => const Gap(10),
          ),
        ),
      ]),
    );
  }

  SliverList _buildRecruitments(
    BuildContext context,
    UserProfileDataModel viewModel,
    UserProfileController controller,
  ) {
    final oemTheme = context.oemTheme;
    final viewPadding = MediaQuery.of(context).viewPadding;

    final requestJoining = useCallback((RecruitmentFull recruitment) {
      return RecruitmentJoinDialog.show(
        context,
        userName: recruitment.user.name,
        onJoin: () async {
          if (viewModel.isCompleted()) {
            await controller.createRecruitmentJoin(
              recruitment.id,
            );
          } else {
            await RecruitmentEntitleConditionBottomSheet.show(
              context,
              achievements: (condition) => switch (condition) {
                RecruitmentEntitleCondition.nickName =>
                  viewModel.isCompletedNickName,
                RecruitmentEntitleCondition.profileImage =>
                  viewModel.isCompletedProfileImage,
                RecruitmentEntitleCondition.subImages =>
                  viewModel.isCompletedSubImage,
                RecruitmentEntitleCondition.selfIntroduction =>
                  viewModel.isCompletedSelfIntroduction,
              },
            );
            if (context.mounted) {
              controller.load(userId);
            }
          }
        },
      );
    }, [controller]);

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          const Gap(40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '公開中の募集',
                  style: oemTheme.textTheme.p16.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(12),
                ...viewModel.userRecruitments.map(
                  (recruitment) {
                    return recruitment.kind ==
                            RecruitmentCreateMethodType.advance
                        ? UserProfileAdvancedRecruitment(
                            onJoin: () => requestJoining(recruitment),
                            description: recruitment.description ?? '',
                            date: recruitment.dateOption.title,
                            capacity: recruitment.capacityOption?.title ?? '',
                            favoriteCasts: recruitment.favoriteCast ?? const [],
                          )
                        : UserProfileSpeedRecruitment(
                            onJoin: () => requestJoining(recruitment),
                            date: recruitment.dateOption.title,
                            activity:
                                recruitment.activities.firstOrNull?.title ?? '',
                            createdAt: recruitment.createdAt,
                          );
                  },
                ),
                const Gap(12),
                Gap(viewPadding.bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showConfirmJoinRecruitment({
    required BuildContext context,
    required String userName,
    required VoidCallback onJoin,
  }) {
    return RecruitmentJoinDialog.show(
      context,
      userName: userName,
      onJoin: onJoin,
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('yyyy.MM.dd HH:mm');
    return formatter.format(dateTime);
  }

  String _genderAgeText({required Gender? gender, required String? ageRange}) {
    final List<String> parts = [];
    if (ageRange != null) {
      parts.add(ageRange);
    }

    if (gender != null) {
      parts.add(gender.name);
    }

    return parts.join('・');
  }

  String? _getUserLinkUserName(List<UserLink>? userLinks, String type) {
    if (userLinks == null) {
      return null;
    }
    String? userName;
    for (final userLink in userLinks) {
      if (userLink.type == type) {
        userName = userLink.userName;
        break;
      }
    }
    return userName;
  }
}
