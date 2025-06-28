import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/core/utils/extension/hook_ext.dart';
import 'package:flutter_clean_architecture/presentation/user_profile/models/user_profile_data_model.dart';
import 'package:flutter_clean_architecture/presentation/user_profile/user_profile_controller.dart';
import 'package:flutter_clean_architecture/presentation/user_profile/user_profile_presenter.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_clean_architecture/core/theme/app_theme.dart';
import 'package:flutter_clean_architecture/core/extensions/context_extension.dart';

@RoutePage()
class UserProfileScreen extends HookConsumerWidget {
  const UserProfileScreen({
    super.key,
    @PathParam('id') required this.userId,
  });

  final int userId;

  static const double _kProfileImageSize = 80.0;
  static const double _kIconSize = 16.0;

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
      appBar: AppBar(
        title: Text(
          'プロフィール',
          style: context.appTheme.textTheme.p16.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
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
              if (viewModel.userRecruitments.isNotEmpty)
                _buildRecruitments(context, viewModel),
          ],
        ),
      ),
    );
  }

  SliverList _buildIntroductionField(
      BuildContext context, UserProfileDataModel viewModel) {
    final appTheme = context.appTheme;

    Widget socialLink({
      required IconData icon,
      required String accountName,
      required VoidCallback onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              icon,
              size: _kIconSize,
              color: appTheme.colorScheme.label,
            ),
            const Gap(2),
            Text(
              accountName,
              style: appTheme.textTheme.p12.copyWith(
                fontWeight: FontWeight.w400,
                color: appTheme.colorScheme.label,
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
              color: appTheme.colorScheme.surface,
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
                        onTap: () {
                          // TODO: Show image viewer
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            _kProfileImageSize / 2,
                          ),
                          child: viewModel.imageUrl.isNotEmpty
                              ? Image.network(
                                  viewModel.imageUrl,
                                  width: _kProfileImageSize,
                                  height: _kProfileImageSize,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: _kProfileImageSize,
                                  height: _kProfileImageSize,
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
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
                                  style: appTheme.textTheme.p20.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: appTheme.colorScheme.label,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (viewModel.isVerified) ...[
                                  const Gap(4),
                                  Icon(
                                    Icons.verified,
                                    size: 18,
                                    color: Colors.blue,
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    viewModel.description,
                    style: appTheme.textTheme.p13.copyWith(
                      fontWeight: FontWeight.w400,
                      color: appTheme.colorScheme.label,
                    ),
                  ),
                  const Gap(8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      socialLink(
                        icon: Icons.camera_alt,
                        accountName: _getUserLinkUserName(
                                viewModel.userLinks, 'instagram') ??
                            '未設定',
                        onTap: () {
                          // TODO: Instagram handling
                        },
                      ),
                      const Gap(8),
                      Container(
                        width: 0.5,
                        height: 12,
                        color: appTheme.colorScheme.tertiary,
                      ),
                      const Gap(8),
                      socialLink(
                        icon: Icons.flutter_dash,
                        accountName: _getUserLinkUserName(
                                viewModel.userLinks, 'twitter') ??
                            '未設定',
                        onTap: () {
                          // TODO: Twitter handling
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

  SliverList _buildRecruitments(
      BuildContext context, UserProfileDataModel viewModel) {
    final appTheme = context.appTheme;
    final viewPadding = MediaQuery.of(context).viewPadding;

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
                  style: appTheme.textTheme.p16.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Gap(12),
                ...viewModel.userRecruitments
                    .map((recruitment) => _buildRecruitmentCard(
                          context,
                          title: recruitment.title,
                          description: recruitment.description,
                          date: recruitment.dateOption.title,
                        )),
                const Gap(12),
                Gap(viewPadding.bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecruitmentCard(
    BuildContext context, {
    required String title,
    required String description,
    required String date,
  }) {
    final appTheme = context.appTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: appTheme.colorScheme.tertiary,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: appTheme.textTheme.p16.copyWith(
              fontWeight: FontWeight.w600,
              color: appTheme.colorScheme.label,
            ),
          ),
          const Gap(4),
          Text(
            description,
            style: appTheme.textTheme.p13.copyWith(
              color: appTheme.colorScheme.label,
            ),
          ),
          const Gap(8),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 16,
                color: appTheme.colorScheme.label,
              ),
              const Gap(4),
              Text(
                date,
                style: appTheme.textTheme.p12.copyWith(
                  color: appTheme.colorScheme.label,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // TODO: Join recruitment
                },
                child: const Text('参加する'),
              ),
            ],
          ),
        ],
      ),
    );
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
