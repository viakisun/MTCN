import React from 'react';
import { motion } from 'framer-motion';
import { designTokens } from '@/styles/design-tokens';
import { getIconComponent } from '@/components/icons/GolfIcons';
import Avatar from '@/components/ui/Avatar';

export interface GroupCardData {
  id: string;
  name: string;
  school: string;
  graduationYear: string;
  memberCount: number;
  recentActivity: string;
  lastActivityDate: string;
  members: Array<{
    id: string;
    name: string;
    avatar?: string;
  }>;
  status: 'active' | 'inactive' | 'new';
  description?: string;
}

interface GroupCardProps {
  data: GroupCardData;
  onClick?: () => void;
  className?: string;
}

export const GroupCard: React.FC<GroupCardProps> = ({ 
  data, 
  onClick,
  className = '' 
}) => {
  const getStatusConfig = () => {
    switch (data.status) {
      case 'active':
        return {
          label: '활성',
          color: designTokens.colors.success[500],
          background: designTokens.colors.success[50],
          border: designTokens.colors.success[200]
        };
      case 'inactive':
        return {
          label: '비활성',
          color: designTokens.colors.neutral[500],
          background: designTokens.colors.neutral[50],
          border: designTokens.colors.neutral[200]
        };
      case 'new':
        return {
          label: '신규',
          color: designTokens.colors.primary[500],
          background: designTokens.colors.primary[50],
          border: designTokens.colors.primary[200]
        };
      default:
        return {
          label: '활성',
          color: designTokens.colors.success[500],
          background: designTokens.colors.success[50],
          border: designTokens.colors.success[200]
        };
    }
  };

  const statusConfig = getStatusConfig();

  const getMembers = () => {
    const maxVisible = 3;
    const visibleMembers = data.members.slice(0, maxVisible);
    const remainingCount = data.members.length - maxVisible;

    return (
      <div style={{ display: 'flex', alignItems: 'center', gap: designTokens.spacing.sm }}>
        <div style={{ display: 'flex', position: 'relative' }}>
          {visibleMembers.map((member, index) => (
            <motion.div
              key={member.id}
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.4 + index * 0.1, duration: 0.3 }}
              style={{
                marginLeft: index > 0 ? `-${designTokens.spacing[3]}` : '0',
                zIndex: visibleMembers.length - index,
                border: `2px solid ${designTokens.colors.neutral[0]}`,
                borderRadius: designTokens.borderRadius.full,
                boxShadow: designTokens.boxShadow.sm,
              }}
            >
              <Avatar name={member.name} avatar={member.avatar} size="sm" />
            </motion.div>
          ))}
          {remainingCount > 0 && (
            <motion.div
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.4 + maxVisible * 0.1, duration: 0.3 }}
              style={{
                marginLeft: `-${designTokens.spacing[3]}`,
                zIndex: 0,
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                width: '32px',
                height: '32px',
                borderRadius: designTokens.borderRadius.full,
                background: `linear-gradient(135deg, ${designTokens.colors.primary[100]} 0%, ${designTokens.colors.primary[200]} 100%)`,
                fontSize: designTokens.typography.fontSize.xs,
                fontWeight: designTokens.typography.fontWeight.semibold,
                color: designTokens.colors.primary[700],
                border: `2px solid ${designTokens.colors.neutral[0]}`,
                boxShadow: designTokens.boxShadow.sm,
              }}
            >
              +{remainingCount}
            </motion.div>
          )}
        </div>
        <span style={{
          fontSize: designTokens.typography.fontSize.sm,
          fontWeight: designTokens.typography.fontWeight.medium,
          color: designTokens.colors.text.secondary
        }}>
          {data.memberCount}명 참여
        </span>
      </div>
    );
  };

  const getInfoItems = () => [
    { 
      icon: getIconComponent('users', { size: 16, color: designTokens.colors.text.secondary }), 
      label: `${data.memberCount}명`,
      color: designTokens.colors.text.secondary
    },
    { 
      icon: getIconComponent('calendar', { size: 16, color: designTokens.colors.text.secondary }), 
      label: data.lastActivityDate,
      color: designTokens.colors.text.secondary
    },
    { 
      icon: getIconComponent('golf-ball', { size: 16, color: designTokens.colors.text.secondary }), 
      label: '골프 동문회',
      color: designTokens.colors.text.secondary
    },
  ];

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.5 }}
      whileHover={{ 
        y: -6,
        scale: 1.02,
        boxShadow: `
          0 12px 32px rgba(0, 0, 0, 0.16),
          0 6px 12px rgba(0, 0, 0, 0.12),
          inset 0 1px 0 rgba(255, 255, 255, 0.15)
        `,
        transition: { duration: 0.3, ease: "easeOut" }
      }}
      onClick={onClick}
      className={`cursor-pointer ${className}`}
      style={{
        background: `
          linear-gradient(135deg, 
            rgba(255, 255, 255, 0.98) 0%, 
            rgba(250, 250, 250, 0.95) 100%
          )
        `,
        backdropFilter: 'blur(20px)',
        borderRadius: designTokens.golf.card.borderRadius,
        border: `1px solid rgba(0, 0, 0, 0.08)`,
        boxShadow: `
          0 8px 24px rgba(0, 0, 0, 0.12),
          0 4px 8px rgba(0, 0, 0, 0.08),
          inset 0 1px 0 rgba(255, 255, 255, 0.1)
        `,
        padding: designTokens.golf.card.padding.md,
        position: 'relative',
        overflow: 'hidden',
      }}
    >
      {/* 배경 패턴 (은은한 동문회 아이덴티티) */}
      <div style={{
        position: 'absolute',
        top: designTokens.spacing.lg,
        right: designTokens.spacing.xl,
        opacity: 0.1,
        pointerEvents: 'none',
        transform: 'rotate(15deg)'
      }}>
        {getIconComponent('users', { size: 60, color: designTokens.colors.primary[300] })}
      </div>

      <div style={{ position: 'relative', zIndex: 1 }}>
        {/* 상단: 동문회명 + 상태 배지 */}
        <div style={{ 
          display: 'flex', 
          justifyContent: 'space-between', 
          alignItems: 'flex-start',
          marginBottom: designTokens.spacing.md
        }}>
          <div style={{ flex: 1, marginRight: designTokens.spacing.md }}>
            {/* 동문회명 - 가장 중요한 정보 */}
            <h3 style={{
              fontSize: designTokens.typography.fontSize.sm,
              fontWeight: designTokens.typography.fontWeight.semibold,
              color: designTokens.colors.text.primary,
              margin: 0,
              marginBottom: designTokens.spacing.xs,
              lineHeight: designTokens.typography.lineHeight.tight,
            }}>
              {data.name}
            </h3>
            
            {/* 학교명 - 보조 정보 */}
            <div style={{
              fontSize: '11px',
              fontWeight: designTokens.typography.fontWeight.medium,
              color: designTokens.colors.text.secondary,
              marginBottom: designTokens.spacing.sm,
            }}>
              {data.school} {data.graduationYear}학번
            </div>
            
            {/* 최근 활동 */}
            <div style={{
              fontSize: '11px',
              fontWeight: designTokens.typography.fontWeight.medium,
              color: designTokens.colors.text.secondary,
              display: 'flex',
              alignItems: 'center',
              gap: designTokens.spacing.sm,
            }}>
              {getIconComponent('golf-ball', { size: 12, color: designTokens.colors.text.secondary })}
              <span>{data.recentActivity}</span>
            </div>
          </div>
          
          {/* 상태 배지 - 오른쪽 상단에 자연스럽게 */}
          <div style={{ 
            display: 'flex', 
            flexDirection: 'column', 
            gap: designTokens.spacing.xs, 
            alignItems: 'flex-end',
            flexShrink: 0
          }}>
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ delay: 0.2, duration: 0.3 }}
              style={{
                background: `
                  linear-gradient(135deg, 
                    ${statusConfig.color} 0%, 
                    ${statusConfig.color}80 50%,
                    ${statusConfig.color}60 100%
                  )
                `,
                borderRadius: '12px',
                padding: `${designTokens.spacing.xs} ${designTokens.spacing.sm}`,
                boxShadow: `
                  0 2px 8px ${statusConfig.color}20,
                  0 1px 2px rgba(0, 0, 0, 0.1)
                `,
                border: `1px solid rgba(255, 255, 255, 0.2)`,
                position: 'relative',
                overflow: 'hidden'
              }}
            >
              <span style={{
                fontSize: designTokens.typography.fontSize.xs,
                fontWeight: designTokens.typography.fontWeight.medium,
                color: designTokens.colors.neutral[0],
                textShadow: '0 1px 2px rgba(0, 0, 0, 0.2)',
                position: 'relative',
                zIndex: 1
              }}>
                {statusConfig.label}
              </span>
            </motion.div>
          </div>
        </div>

        {/* 핵심 정보 섹션 - 일관된 디자인 */}
        <div style={{ 
          display: 'flex', 
          justifyContent: 'space-between', 
          alignItems: 'center',
          background: `linear-gradient(90deg, ${designTokens.colors.neutral[50]} 0%, ${designTokens.colors.neutral[100]} 100%)`,
          borderRadius: designTokens.borderRadius.md,
          padding: `${designTokens.spacing.sm} ${designTokens.spacing.md}`,
          marginBottom: designTokens.spacing.lg,
          boxShadow: `inset 0 1px 3px rgba(0,0,0,0.05)`
        }}>
          {getInfoItems().map((item, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.5 + index * 0.1, duration: 0.3 }}
              whileHover={{ 
                y: -2,
                transition: { duration: 0.1 }
              }}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: designTokens.spacing.xs,
                fontSize: designTokens.typography.fontSize.sm,
                fontWeight: designTokens.typography.fontWeight.medium,
                color: item.color,
              }}
            >
              {item.icon}
              <span>{item.label}</span>
            </motion.div>
          ))}
        </div>

        {/* 참가자 아바타 */}
        <div style={{ 
          marginBottom: designTokens.spacing.lg
        }}>
          {getMembers()}
        </div>

        {/* 풀-위드스 CTA 버튼 */}
        <div style={{ marginBottom: designTokens.spacing.md }}>
          <motion.div
            whileHover={{ 
              scale: 1.02,
              boxShadow: `0 8px 20px ${statusConfig.color}40`,
              transition: { duration: 0.2 }
            }}
            whileTap={{ 
              scale: 0.98,
              transition: { duration: 0.1 }
            }}
            style={{
              width: '100%',
              display: 'inline-block',
              background: `
                linear-gradient(135deg, 
                  ${statusConfig.color} 0%, 
                  ${statusConfig.color}80 50%,
                  ${statusConfig.color}60 100%
                )
              `,
              borderRadius: '16px',
              padding: `${designTokens.spacing.xs} ${designTokens.spacing.lg}`,
              boxShadow: `
                0 6px 16px ${statusConfig.color}30,
                0 2px 4px rgba(0, 0, 0, 0.1),
                inset 0 1px 0 rgba(255, 255, 255, 0.2)
              `,
              border: `1px solid rgba(255, 255, 255, 0.2)`,
              cursor: 'pointer',
              position: 'relative',
              overflow: 'hidden',
              textAlign: 'center'
            }}
          >
            <span style={{
              fontSize: designTokens.typography.fontSize.sm,
              fontWeight: designTokens.typography.fontWeight.semibold,
              color: designTokens.colors.neutral[0],
              textShadow: '0 1px 2px rgba(0, 0, 0, 0.3)',
              position: 'relative',
              zIndex: 1
            }}>
              참가신청
            </span>
          </motion.div>
        </div>

        {/* 설명 박스 */}
        {data.description && (
          <div style={{
            textAlign: 'center',
            fontSize: designTokens.typography.fontSize.xs,
            color: designTokens.colors.text.secondary,
            fontWeight: designTokens.typography.fontWeight.normal,
            lineHeight: designTokens.typography.lineHeight.relaxed,
            opacity: 0.8
          }}>
            {data.description}
          </div>
        )}
      </div>
    </motion.div>
  );
};