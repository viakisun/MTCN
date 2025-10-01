'use client';

import React from 'react';
import { motion } from 'framer-motion';
import { designTokens } from '@/styles/design-tokens';
import { Player } from '@/lib/mock-data';

interface LiveScoreboardProps {
  players: Player[];
  currentHole: number;
  onPlayerClick?: (player: Player) => void;
}

export const LiveScoreboard: React.FC<LiveScoreboardProps> = ({
  players,
  currentHole,
  onPlayerClick
}) => {
  // 플레이어를 조별로 그룹화
  const groupedPlayers = players.reduce((groups, player, index) => {
    const groupIndex = Math.floor(index / 4);
    if (!groups[groupIndex]) {
      groups[groupIndex] = [];
    }
    groups[groupIndex].push(player);
    return groups;
  }, [] as Player[][]);

  // 스코어 기준으로 정렬
  const sortedPlayers = players
    .filter(p => p.isPlaying)
    .sort((a, b) => (a.currentScore || 0) - (b.currentScore || 0));

  return (
    <div className="absolute top-4 left-4 right-4 z-20">
      {/* 현재 홀 정보 */}
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        className="bg-white rounded-lg shadow-lg p-3 mb-3"
        style={{
          border: `1px solid ${designTokens.colors.border.light}`,
        }}
      >
        <div className="flex items-center justify-between">
          <div>
            <div className="text-sm font-bold text-gray-800">
              {currentHole}홀 (파 4)
            </div>
            <div className="text-xs text-gray-600">
              활성 플레이어: {players.filter(p => p.isPlaying).length}명
            </div>
          </div>
          <div className="flex items-center gap-2">
            <div className="w-2 h-2 bg-green-500 rounded-full animate-pulse"></div>
            <span className="text-xs text-gray-600">LIVE</span>
          </div>
        </div>
      </motion.div>

      {/* 실시간 리더보드 */}
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.2 }}
        className="bg-white rounded-lg shadow-lg overflow-hidden"
        style={{
          border: `1px solid ${designTokens.colors.border.light}`,
          maxHeight: '200px',
        }}
      >
        <div className="p-3 border-b" style={{ borderColor: designTokens.colors.border.medium }}>
          <div className="flex items-center gap-2">
            <span className="text-sm font-bold text-gray-800">🏆 실시간 리더보드</span>
            <div className="w-1 h-1 bg-gray-400 rounded-full animate-pulse"></div>
          </div>
        </div>
        
        <div className="overflow-y-auto" style={{ maxHeight: '150px' }}>
          {sortedPlayers.slice(0, 8).map((player, index) => (
            <motion.div
              key={player.id}
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: index * 0.1 }}
              className="flex items-center gap-3 p-3 hover:bg-gray-50 cursor-pointer"
              onClick={() => onPlayerClick?.(player)}
              whileHover={{ backgroundColor: '#F9FAFB' }}
            >
              {/* 순위 */}
              <div className="w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold"
                   style={{
                     background: index === 0 ? '#FFD700' : index === 1 ? '#C0C0C0' : index === 2 ? '#CD7F32' : '#E5E7EB',
                     color: index < 3 ? 'white' : '#6B7280'
                   }}>
                {index + 1}
              </div>
              
              {/* 플레이어 아바타 */}
              <div
                className="w-8 h-8 rounded-full flex items-center justify-center text-white font-bold text-sm"
                style={{
                  background: designTokens.colors.gradient.blue,
                }}
              >
                {player.lastName}
              </div>
              
              {/* 플레이어 정보 */}
              <div className="flex-1 min-w-0">
                <div className="text-sm font-semibold text-gray-800 truncate">
                  {player.name}
                </div>
                <div className="text-xs text-gray-600">
                  {player.currentHole || 1}홀 · 핸디캡 {player.handicap}
                </div>
              </div>
              
              {/* 현재 스코어 */}
              <div className="text-right">
                <div className="text-lg font-bold" style={{
                  color: player.currentScore && player.currentScore <= 72 ? '#16A34A' : 
                         player.currentScore && player.currentScore <= 80 ? '#2563EB' : '#F59E0B'
                }}>
                  {player.currentScore || 0}
                </div>
                <div className="text-xs text-gray-500">타</div>
              </div>
              
              {/* 상태 표시 */}
              <div className="w-2 h-2 rounded-full"
                   style={{
                     background: player.isPlaying ? '#10B981' : '#9CA3AF'
                   }}>
              </div>
            </motion.div>
          ))}
        </div>
      </motion.div>

      {/* 조별 현황 */}
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ delay: 0.4 }}
        className="bg-white rounded-lg shadow-lg p-3 mt-3"
        style={{
          border: `1px solid ${designTokens.colors.border.light}`,
        }}
      >
        <div className="text-sm font-bold text-gray-800 mb-2">👥 조별 현황</div>
        <div className="grid grid-cols-2 gap-2">
          {groupedPlayers.map((group, groupIndex) => (
            <div key={groupIndex} className="text-xs">
              <div className="font-semibold text-gray-700 mb-1">
                {groupIndex + 1}조 ({group.filter(p => p.isPlaying).length}/4)
              </div>
              <div className="flex gap-1">
                {group.map((player, playerIndex) => (
                  <div
                    key={player.id}
                    className="w-5 h-5 rounded-full flex items-center justify-center text-white text-xs font-bold"
                    style={{
                      background: player.isPlaying ? designTokens.colors.gradient.blue : '#9CA3AF',
                    }}
                    title={player.name}
                  >
                    {player.lastName}
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>
      </motion.div>
    </div>
  );
};

export default LiveScoreboard;


