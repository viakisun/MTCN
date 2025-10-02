import React from 'react';
import { motion } from 'framer-motion';
import { ActivityItem, Card, Button, EmptyState } from '@/components/ui';
import { designTokens } from '@/styles/design-tokens';

interface GroupActivity {
  id: string;
  groupName: string;
  activity: string;
  time: string;
  avatar?: string;
}

interface GroupActivityProps {
  activities: GroupActivity[];
  onViewAllGroups?: () => void;
  onViewGroupChat?: (id: string) => void;
  className?: string;
}

const GroupActivity: React.FC<GroupActivityProps> = ({
  activities,
  onViewAllGroups,
  onViewGroupChat,
  className = ''
}) => {
  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ delay: 0.4, duration: 0.5 }}
      className={className}
    >
      <div style={{
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        marginBottom: designTokens.spacing.lg
      }}>
        <h2 style={{
          fontSize: designTokens.typography.fontSize['4xl'],
          fontWeight: designTokens.typography.fontWeight.bold,
          color: designTokens.colors.text.primary,
          margin: 0
        }}>
          동문회 활동
        </h2>
        <Button 
          variant="text" 
          onClick={onViewAllGroups}
          size="sm"
        >
          전체보기
        </Button>
      </div>

      {activities.length === 0 ? (
        <EmptyState
          icon="👥"
          title="최근 동문회 활동이 없습니다"
          description="동문회에 참여하여 활동을 시작해보세요"
        />
      ) : (
        <div style={{
          display: 'flex',
          flexDirection: 'column',
          gap: designTokens.spacing.md
        }}>
          {activities.map((activity) => (
            <Card 
              key={activity.id}
              className="p-4 cursor-pointer hover:shadow-md transition-all duration-200"
              onClick={() => onViewGroupChat?.(activity.id)}
            >
              <div style={{
                display: 'flex',
                alignItems: 'center',
                gap: designTokens.spacing.md
              }}>
                <div style={{
                  width: '40px',
                  height: '40px',
                  borderRadius: '50%',
                  background: activity.avatar 
                    ? `url(${activity.avatar}) center/cover no-repeat`
                    : 'linear-gradient(135deg, #2563EB, #1D4ED8)',
                  color: 'white',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  fontSize: '18px',
                  fontWeight: 600,
                  flexShrink: 0
                }}>
                  {!activity.avatar && activity.groupName.charAt(0)}
                </div>
                
                <div style={{ flex: 1, minWidth: 0 }}>
                  <h4 style={{
                    fontSize: designTokens.typography.fontSize.base,
                    fontWeight: designTokens.typography.fontWeight.medium,
                    color: designTokens.colors.text.primary,
                    margin: 0,
                    marginBottom: designTokens.spacing.xs,
                    lineHeight: 1.4
                  }}>
                    {activity.groupName}
                  </h4>
                  <p style={{
                    fontSize: designTokens.typography.fontSize.sm,
                    color: designTokens.colors.text.secondary,
                    margin: 0,
                    marginBottom: designTokens.spacing.xs,
                    lineHeight: 1.4
                  }}>
                    {activity.activity}
                  </p>
                  <p style={{
                    fontSize: designTokens.typography.fontSize.xs,
                    color: designTokens.colors.text.tertiary,
                    margin: 0
                  }}>
                    {activity.time}
                  </p>
                </div>

                <div style={{
                  fontSize: '16px',
                  color: designTokens.colors.text.secondary
                }}>
                  ›
                </div>
              </div>
            </Card>
          ))}
        </div>
      )}
    </motion.div>
  );
};

export default GroupActivity;
