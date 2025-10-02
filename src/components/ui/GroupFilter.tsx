import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { designTokens } from '@/styles/design-tokens';
import { getIconComponent } from '@/components/icons/GolfIcons';

export interface GroupFilterOption {
  id: string;
  label: string;
  icon?: string;
  count?: number;
}

export interface GroupFilterProps {
  activeFilter: string;
  onFilterChange: (filterId: string) => void;
  filters: GroupFilterOption[];
  searchQuery: string;
  onSearchChange: (query: string) => void;
  className?: string;
}

export const GroupFilter: React.FC<GroupFilterProps> = ({
  activeFilter,
  onFilterChange,
  filters,
  searchQuery,
  onSearchChange,
  className = ''
}) => {
  const [isSearchFocused, setIsSearchFocused] = useState(false);

  return (
    <div className={`w-full ${className}`}>
      {/* 검색 바 */}
      <motion.div
        initial={{ opacity: 0, y: -10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.1, duration: 0.3 }}
        style={{
          position: 'relative',
          marginBottom: designTokens.spacing.lg,
        }}
      >
        <div
          style={{
            position: 'relative',
            display: 'flex',
            alignItems: 'center',
          }}
        >
          {/* 검색 아이콘 */}
          <div
            style={{
              position: 'absolute',
              left: designTokens.spacing.md,
              zIndex: 2,
              display: 'flex',
              alignItems: 'center',
              justifyContent: 'center',
              width: '20px',
              height: '20px',
            }}
          >
            {getIconComponent('search', { 
              size: 16, 
              color: isSearchFocused 
                ? designTokens.colors.primary[600] 
                : designTokens.colors.text.secondary 
            })}
          </div>

          {/* 검색 입력 */}
          <input
            type="text"
            placeholder="동문회명, 학교명으로 검색..."
            value={searchQuery}
            onChange={(e) => onSearchChange(e.target.value)}
            onFocus={() => setIsSearchFocused(true)}
            onBlur={() => setIsSearchFocused(false)}
            style={{
              width: '100%',
              height: '48px',
              padding: `${designTokens.spacing.sm} ${designTokens.spacing.sm} ${designTokens.spacing.sm} ${designTokens.spacing['3xl']}`,
              border: `2px solid ${isSearchFocused 
                ? designTokens.colors.primary[600] 
                : designTokens.colors.neutral[200]
              }`,
              borderRadius: designTokens.borderRadius.lg,
              fontSize: designTokens.typography.fontSize.sm,
              fontWeight: designTokens.typography.fontWeight.medium,
              color: designTokens.colors.text.primary,
              backgroundColor: designTokens.colors.neutral[0],
              outline: 'none',
              transition: 'all 0.2s ease',
              boxShadow: isSearchFocused 
                ? `0 0 0 3px ${designTokens.colors.primary[600]}20`
                : designTokens.boxShadow.sm,
            }}
          />

          {/* 검색어 지우기 버튼 */}
          {searchQuery && (
            <motion.button
              initial={{ opacity: 0, scale: 0 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0 }}
              onClick={() => onSearchChange('')}
              style={{
                position: 'absolute',
                right: designTokens.spacing.md,
                zIndex: 2,
                width: '20px',
                height: '20px',
                borderRadius: designTokens.borderRadius.full,
                backgroundColor: designTokens.colors.neutral[300],
                border: 'none',
                cursor: 'pointer',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                transition: 'all 0.2s ease',
              }}
              whileHover={{ 
                backgroundColor: designTokens.colors.neutral[400],
                scale: 1.1 
              }}
              whileTap={{ scale: 0.9 }}
            >
              {getIconComponent('close', { 
                size: 12, 
                color: designTokens.colors.text.secondary 
              })}
            </motion.button>
          )}
        </div>
      </motion.div>

      {/* 필터 탭 */}
      <motion.div
        initial={{ opacity: 0, y: -10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2, duration: 0.3 }}
        style={{
          display: 'flex',
          gap: designTokens.spacing.xs,
          marginBottom: designTokens.spacing.lg,
          overflowX: 'auto',
          paddingBottom: designTokens.spacing.xs,
        }}
      >
        {filters.map((filter) => {
          const isActive = activeFilter === filter.id;
          
          return (
            <motion.button
              key={filter.id}
              onClick={() => onFilterChange(filter.id)}
              whileTap={{ scale: 0.95 }}
              whileHover={{ scale: 1.02 }}
              style={{
                display: 'flex',
                alignItems: 'center',
                gap: designTokens.spacing.xs,
                padding: `${designTokens.spacing.sm} ${designTokens.spacing.md}`,
                borderRadius: designTokens.borderRadius.lg,
                border: `2px solid ${isActive 
                  ? designTokens.colors.primary[600] 
                  : designTokens.colors.neutral[200]
                }`,
                backgroundColor: isActive 
                  ? designTokens.colors.primary[50]
                  : designTokens.colors.neutral[0],
                cursor: 'pointer',
                transition: 'all 0.2s ease',
                minWidth: 'fit-content',
                whiteSpace: 'nowrap',
                boxShadow: isActive 
                  ? `0 4px 12px ${designTokens.colors.primary[600]}20`
                  : designTokens.boxShadow.sm,
              }}
            >
              {/* 필터 아이콘 */}
              {filter.icon && (
                <div style={{ display: 'flex', alignItems: 'center' }}>
                  {getIconComponent(filter.icon, { 
                    size: 16, 
                    color: isActive 
                      ? designTokens.colors.primary[600] 
                      : designTokens.colors.text.secondary 
                  })}
                </div>
              )}

              {/* 필터 라벨 */}
              <span
                style={{
                  fontSize: designTokens.typography.fontSize.sm,
                  fontWeight: isActive 
                    ? designTokens.typography.fontWeight.semibold
                    : designTokens.typography.fontWeight.medium,
                  color: isActive 
                    ? designTokens.colors.primary[600] 
                    : designTokens.colors.text.secondary,
                }}
              >
                {filter.label}
              </span>

              {/* 카운트 배지 */}
              {filter.count !== undefined && filter.count > 0 && (
                <motion.div
                  initial={{ scale: 0 }}
                  animate={{ scale: 1 }}
                  transition={{ delay: 0.1 }}
                  style={{
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    minWidth: '20px',
                    height: '20px',
                    borderRadius: designTokens.borderRadius.full,
                    backgroundColor: isActive 
                      ? designTokens.colors.primary[600]
                      : designTokens.colors.neutral[300],
                    fontSize: designTokens.typography.fontSize.xs,
                    fontWeight: designTokens.typography.fontWeight.semibold,
                    color: isActive 
                      ? designTokens.colors.neutral[0]
                      : designTokens.colors.text.secondary,
                  }}
                >
                  {filter.count}
                </motion.div>
              )}
            </motion.button>
          );
        })}
      </motion.div>
    </div>
  );
};

export default GroupFilter;
