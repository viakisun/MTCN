"use client";

import React from 'react';
import { motion } from 'framer-motion';
import GroupsMainPage from '@/components/pages/GroupsMainPage';

const GroupsPage: React.FC = () => {
  return (
    <GroupsMainPage 
      onBack={() => {}}
      onGroupChat={() => console.log('동문회 채팅으로 이동')}
      onCreateGroup={() => console.log('새 동문회 만들기')}
    />
  );
};

export default GroupsPage;
