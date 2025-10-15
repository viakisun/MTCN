/// 그룹 관련 열거형들

/// 그룹 프라이버시 설정
enum GroupPrivacy {
  public('공개', 'public'),
  private('비공개', 'private'),
  inviteOnly('초대만', 'invite_only');

  const GroupPrivacy(this.displayName, this.apiValue);

  final String displayName;
  final String apiValue;

  static GroupPrivacy fromString(String value) {
    switch (value) {
      case '공개':
      case 'public':
        return GroupPrivacy.public;
      case '비공개':
      case 'private':
        return GroupPrivacy.private;
      case '초대만':
      case 'invite_only':
      case 'inviteOnly':
        return GroupPrivacy.inviteOnly;
      default:
        return GroupPrivacy.public;
    }
  }
}

/// 그룹 상태
enum GroupStatus {
  active('활성', 'active'),
  inactive('비활성', 'inactive'),
  archived('보관됨', 'archived'),
  deleted('삭제됨', 'deleted');

  const GroupStatus(this.displayName, this.apiValue);

  final String displayName;
  final String apiValue;

  static GroupStatus fromString(String value) {
    switch (value) {
      case '활성':
      case 'active':
        return GroupStatus.active;
      case '비활성':
      case 'inactive':
        return GroupStatus.inactive;
      case '보관됨':
      case 'archived':
        return GroupStatus.archived;
      case '삭제됨':
      case 'deleted':
        return GroupStatus.deleted;
      default:
        return GroupStatus.active;
    }
  }
}

/// 멤버 역할
enum MemberRole {
  owner('소유자', 'owner'),
  admin('관리자', 'admin'),
  moderator('운영자', 'moderator'),
  member('멤버', 'member');

  const MemberRole(this.displayName, this.apiValue);

  final String displayName;
  final String apiValue;

  static MemberRole fromString(String value) {
    switch (value) {
      case '소유자':
      case 'owner':
        return MemberRole.owner;
      case '관리자':
      case 'admin':
        return MemberRole.admin;
      case '운영자':
      case 'moderator':
        return MemberRole.moderator;
      case '멤버':
      case 'member':
        return MemberRole.member;
      default:
        return MemberRole.member;
    }
  }
}

/// 멤버 상태
enum MemberStatus {
  active('활성', 'active'),
  pending('대기중', 'pending'),
  rejected('거절됨', 'rejected'),
  left('나감', 'left'),
  banned('차단됨', 'banned');

  const MemberStatus(this.displayName, this.apiValue);

  final String displayName;
  final String apiValue;

  static MemberStatus fromString(String value) {
    switch (value) {
      case '활성':
      case 'active':
        return MemberStatus.active;
      case '대기중':
      case 'pending':
        return MemberStatus.pending;
      case '거절됨':
      case 'rejected':
        return MemberStatus.rejected;
      case '나감':
      case 'left':
        return MemberStatus.left;
      case '차단됨':
      case 'banned':
        return MemberStatus.banned;
      default:
        return MemberStatus.pending;
    }
  }
}

/// 초대 상태
enum InvitationStatus {
  pending('대기중', 'pending'),
  accepted('수락됨', 'accepted'),
  declined('거절됨', 'declined'),
  expired('만료됨', 'expired');

  const InvitationStatus(this.displayName, this.apiValue);

  final String displayName;
  final String apiValue;

  static InvitationStatus fromString(String value) {
    switch (value) {
      case '대기중':
      case 'pending':
        return InvitationStatus.pending;
      case '수락됨':
      case 'accepted':
        return InvitationStatus.accepted;
      case '거절됨':
      case 'declined':
        return InvitationStatus.declined;
      case '만료됨':
      case 'expired':
        return InvitationStatus.expired;
      default:
        return InvitationStatus.pending;
    }
  }
}

/// 그룹 크기 등급
enum GroupSizeTier {
  mega, // 100+ members
  large, // 50-99 members
  medium, // 20-49 members
  small, // 10-19 members
  mini, // 0-9 members
}

/// 그룹 카테고리
enum GroupCategory {
  golf('골프', 'golf'),
  sports('스포츠', 'sports'),
  social('사교', 'social'),
  business('비즈니스', 'business'),
  hobby('취미', 'hobby'),
  other('기타', 'other');

  const GroupCategory(this.displayName, this.apiValue);

  final String displayName;
  final String apiValue;

  static GroupCategory fromString(String value) {
    switch (value) {
      case '골프':
      case 'golf':
        return GroupCategory.golf;
      case '스포츠':
      case 'sports':
        return GroupCategory.sports;
      case '사교':
      case 'social':
        return GroupCategory.social;
      case '비즈니스':
      case 'business':
        return GroupCategory.business;
      case '취미':
      case 'hobby':
        return GroupCategory.hobby;
      case '기타':
      case 'other':
        return GroupCategory.other;
      default:
        return GroupCategory.golf;
    }
  }
}
