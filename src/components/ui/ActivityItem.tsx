import React from 'react';
import { Avatar, Card } from '@/components/ui';
import { dateUtils } from '@/utils';
import { designTokens } from '@/styles/design-tokens';

interface ActivityItemProps {
  id: string;
  type: 'rounding' | 'score' | 'group' | 'message';
  title: string;
  description: string;
  timestamp: string;
  user?: {
    name: string;
    avatar?: string;
  };
  icon?: string;
  onClick?: () => void;
  className?: string;
}

const ActivityItem: React.FC<ActivityItemProps> = ({
  id,
  type,
  title,
  description,
  timestamp,
  user,
  icon,
  onClick,
  className = ''
}) => {
  const getTypeIcon = (type: string) => {
    switch (type) {
      case 'rounding': return '⛳';
      case 'score': return '📊';
      case 'group': return '👥';
      case 'message': return '💬';
      default: return '📝';
    }
  };

  const getTypeColor = (type: string) => {
    switch (type) {
      case 'rounding': return '#10B981';
      case 'score': return '#3B82F6';
      case 'group': return '#8B5CF6';
      case 'message': return '#F59E0B';
      default: return '#6B7280';
    }
  };

  return (
    <Card 
      className={`hover:shadow-md transition-all duration-200 ${className}`}
      onClick={onClick}
      hover
    >
      <div style={{ padding: designTokens.spacing.lg }}>
        <div style={{
          display: 'flex',
          alignItems: 'flex-start',
          gap: designTokens.spacing.md
        }}>
          {/* 아이콘 */}
          <div style={{
            width: '40px',
            height: '40px',
            borderRadius: '50%',
            background: getTypeColor(type),
            color: 'white',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            fontSize: '18px',
            flexShrink: 0
          }}>
            {icon || getTypeIcon(type)}
          </div>

          {/* 콘텐츠 */}
          <div style={{ flex: 1, minWidth: 0 }}>
            <div style={{
              display: 'flex',
              justifyContent: 'space-between',
              alignItems: 'flex-start',
              marginBottom: designTokens.spacing.xs
            }}>
              <h4 style={{
                fontSize: designTokens.typography.fontSize.base,
                fontWeight: designTokens.typography.fontWeight.medium,
                color: designTokens.colors.text.primary,
                margin: 0,
                lineHeight: 1.4
              }}>
                {title}
              </h4>
              <span style={{
                fontSize: designTokens.typography.fontSize.xs,
                color: designTokens.colors.text.secondary,
                whiteSpace: 'nowrap',
                marginLeft: designTokens.spacing.sm
              }}>
                {dateUtils.getRelativeTime(timestamp)}
              </span>
            </div>

            <p style={{
              fontSize: designTokens.typography.fontSize.sm,
              color: designTokens.colors.text.secondary,
              margin: 0,
              lineHeight: 1.4,
              marginBottom: designTokens.spacing.sm
            }}>
              {description}
            </p>

            {/* 사용자 정보 */}
            {user && (
              <div style={{
                display: 'flex',
                alignItems: 'center',
                gap: designTokens.spacing.sm
              }}>
                <Avatar 
                  name={user.name}
                  avatar={user.avatar}
                  size="sm"
                />
                <span style={{
                  fontSize: designTokens.typography.fontSize.xs,
                  color: designTokens.colors.text.tertiary
                }}>
                  {user.name}
                </span>
              </div>
            )}
          </div>
        </div>
      </div>
    </Card>
  );
};

export default ActivityItem;
