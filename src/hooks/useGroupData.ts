import { useMemo } from 'react';
import { useAppStore } from '@/lib/store';
import { GroupsPageData } from '@/types';

export const useGroupData = (): GroupsPageData => {
  const { groups, messages } = useAppStore();

  const selectedGroup = useMemo(() => {
    return groups.find(group => group.isJoined) || null;
  }, [groups]);

  const chatMessages = useMemo(() => {
    return messages || [];
  }, [messages]);

  return {
    groups,
    selectedGroup,
    chatMessages
  };
};
