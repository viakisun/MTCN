'use client';

import React, { useEffect, useRef, useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { designTokens } from '@/styles/design-tokens';
import { Player } from '@/lib/mock-data';

interface GolfCourseMapProps {
  players: Player[];
  currentHole: number;
  onPlayerClick?: (player: Player) => void;
  isSpectatorMode?: boolean;
}

interface Hole {
  id: number;
  par: number;
  position: { x: number; y: number };
  teeBox: { x: number; y: number };
  green: { x: number; y: number };
}

// 스카이72 골프장 18홀 데이터 (더 현실적인 레이아웃)
const golfCourseHoles: Hole[] = [
  { id: 1, par: 4, position: { x: 15, y: 20 }, teeBox: { x: 15, y: 20 }, green: { x: 75, y: 25 } },
  { id: 2, par: 3, position: { x: 80, y: 30 }, teeBox: { x: 80, y: 30 }, green: { x: 80, y: 65 } },
  { id: 3, par: 5, position: { x: 75, y: 70 }, teeBox: { x: 75, y: 70 }, green: { x: 20, y: 75 } },
  { id: 4, par: 4, position: { x: 15, y: 80 }, teeBox: { x: 15, y: 80 }, green: { x: 70, y: 85 } },
  { id: 5, par: 3, position: { x: 75, y: 90 }, teeBox: { x: 75, y: 90 }, green: { x: 40, y: 90 } },
  { id: 6, par: 4, position: { x: 35, y: 85 }, teeBox: { x: 35, y: 85 }, green: { x: 35, y: 40 } },
  { id: 7, par: 5, position: { x: 30, y: 35 }, teeBox: { x: 30, y: 35 }, green: { x: 80, y: 30 } },
  { id: 8, par: 3, position: { x: 85, y: 25 }, teeBox: { x: 85, y: 25 }, green: { x: 85, y: 50 } },
  { id: 9, par: 4, position: { x: 80, y: 55 }, teeBox: { x: 80, y: 55 }, green: { x: 20, y: 50 } },
  { id: 10, par: 4, position: { x: 15, y: 45 }, teeBox: { x: 15, y: 45 }, green: { x: 70, y: 40 } },
  { id: 11, par: 3, position: { x: 75, y: 35 }, teeBox: { x: 75, y: 35 }, green: { x: 40, y: 35 } },
  { id: 12, par: 5, position: { x: 35, y: 30 }, teeBox: { x: 35, y: 30 }, green: { x: 35, y: 70 } },
  { id: 13, par: 4, position: { x: 30, y: 75 }, teeBox: { x: 30, y: 75 }, green: { x: 80, y: 80 } },
  { id: 14, par: 3, position: { x: 85, y: 85 }, teeBox: { x: 85, y: 85 }, green: { x: 85, y: 60 } },
  { id: 15, par: 4, position: { x: 80, y: 55 }, teeBox: { x: 80, y: 55 }, green: { x: 20, y: 60 } },
  { id: 16, par: 5, position: { x: 15, y: 65 }, teeBox: { x: 15, y: 65 }, green: { x: 70, y: 70 } },
  { id: 17, par: 3, position: { x: 75, y: 75 }, teeBox: { x: 75, y: 75 }, green: { x: 40, y: 75 } },
  { id: 18, par: 4, position: { x: 35, y: 70 }, teeBox: { x: 35, y: 70 }, green: { x: 35, y: 25 } },
];

export const GolfCourseMap: React.FC<GolfCourseMapProps> = ({
  players,
  currentHole,
  onPlayerClick,
  isSpectatorMode = false
}) => {
  const svgRef = useRef<SVGSVGElement>(null);
  const [selectedPlayer, setSelectedPlayer] = useState<Player | null>(null);
  const [zoom, setZoom] = useState(1);
  const [pan, setPan] = useState({ x: 0, y: 0 });

  // 줌 인/아웃 핸들러
  const handleZoom = (delta: number) => {
    setZoom(prev => Math.max(0.5, Math.min(2, prev + delta)));
  };

  // 팬 핸들러
  const handlePan = (deltaX: number, deltaY: number) => {
    setPan(prev => ({
      x: prev.x + deltaX,
      y: prev.y + deltaY
    }));
  };

  // 플레이어 클릭 핸들러
  const handlePlayerClick = (player: Player) => {
    setSelectedPlayer(player);
    onPlayerClick?.(player);
  };

  return (
    <div className="relative w-full h-full bg-green-50 overflow-hidden">
      {/* 컨트롤 버튼들 */}
      <div className="absolute top-4 right-4 z-10 flex flex-col gap-2">
        <motion.button
          className="w-10 h-10 bg-white rounded-full shadow-lg flex items-center justify-center"
          onClick={() => handleZoom(0.2)}
          whileHover={{ scale: 1.1 }}
          whileTap={{ scale: 0.9 }}
        >
          <span className="text-lg">+</span>
        </motion.button>
        <motion.button
          className="w-10 h-10 bg-white rounded-full shadow-lg flex items-center justify-center"
          onClick={() => handleZoom(-0.2)}
          whileHover={{ scale: 1.1 }}
          whileTap={{ scale: 0.9 }}
        >
          <span className="text-lg">−</span>
        </motion.button>
      </div>

      {/* 골프장 지도 SVG */}
      <svg
        ref={svgRef}
        className="w-full h-full"
        viewBox="0 0 100 100"
        style={{
          transform: `scale(${zoom}) translate(${pan.x}px, ${pan.y}px)`,
          transformOrigin: 'center center',
        }}
      >
        {/* 골프장 배경 */}
        <rect width="100" height="100" fill="#E8F5E8" />
        
        {/* 페어웨이 */}
        <rect x="10" y="10" width="80" height="80" fill="#90EE90" rx="5" />
        
        {/* 홀별 티박스와 그린 */}
        {golfCourseHoles.map((hole) => (
          <g key={hole.id}>
            {/* 티박스 */}
            <circle
              cx={hole.teeBox.x}
              cy={hole.teeBox.y}
              r="1.5"
              fill={hole.id === currentHole ? "#FF6B6B" : "#8B4513"}
              stroke="white"
              strokeWidth="0.2"
            />
            
            {/* 그린 */}
            <circle
              cx={hole.green.x}
              cy={hole.green.y}
              r="2"
              fill={hole.id === currentHole ? "#FFD700" : "#228B22"}
              stroke="white"
              strokeWidth="0.2"
            />
            
            {/* 홀 번호 */}
            <text
              x={hole.position.x}
              y={hole.position.y - 0.5}
              textAnchor="middle"
              fontSize="1.2"
              fill={hole.id === currentHole ? "#FF6B6B" : "#333"}
              fontWeight="bold"
            >
              {hole.id}
            </text>
            
            {/* 파 표시 */}
            <text
              x={hole.position.x}
              y={hole.position.y + 0.8}
              textAnchor="middle"
              fontSize="0.8"
              fill="#666"
            >
              {hole.par}
            </text>
          </g>
        ))}
        
        {/* 플레이어 마커들 */}
        <AnimatePresence>
          {players.map((player) => (
            <motion.g
              key={player.id}
              initial={{ scale: 0, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0, opacity: 0 }}
              transition={{ duration: 0.3 }}
            >
              {/* 플레이어 위치 */}
              <motion.circle
                cx={player.position?.x || 50}
                cy={player.position?.y || 50}
                r="1.2"
                fill={player.isPlaying ? "#2563EB" : "#9CA3AF"}
                stroke="white"
                strokeWidth="0.3"
                className="cursor-pointer"
                onClick={() => handlePlayerClick(player)}
                whileHover={{ scale: 1.3 }}
                animate={{
                  scale: [1, 1.1, 1],
                }}
                transition={{
                  duration: 2,
                  repeat: Infinity,
                  ease: "easeInOut"
                }}
              />
              
              {/* 플레이어 이름 */}
              <text
                x={player.position?.x || 50}
                y={(player.position?.y || 50) - 2}
                textAnchor="middle"
                fontSize="0.8"
                fill="#333"
                fontWeight="bold"
              >
                {player.lastName}
              </text>
              
              {/* 현재 스코어 */}
              <text
                x={player.position?.x || 50}
                y={(player.position?.y || 50) + 2.5}
                textAnchor="middle"
                fontSize="0.6"
                fill="#666"
              >
                {player.currentScore || 0}타
              </text>
            </motion.g>
          ))}
        </AnimatePresence>
        
        {/* 현재 홀 하이라이트 */}
        <motion.circle
          cx={golfCourseHoles[currentHole - 1]?.position.x || 50}
          cy={golfCourseHoles[currentHole - 1]?.position.y || 50}
          r="3"
          fill="none"
          stroke="#FF6B6B"
          strokeWidth="0.5"
          strokeDasharray="1,1"
          animate={{
            strokeDashoffset: [0, 2],
          }}
          transition={{
            duration: 1,
            repeat: Infinity,
            ease: "linear"
          }}
        />
      </svg>

      {/* 플레이어 상세 정보 팝업 */}
      <AnimatePresence>
        {selectedPlayer && (
          <motion.div
            initial={{ opacity: 0, scale: 0.8 }}
            animate={{ opacity: 1, scale: 1 }}
            exit={{ opacity: 0, scale: 0.8 }}
            className="absolute bottom-4 left-4 right-4 bg-white rounded-lg shadow-lg p-4 z-20"
            style={{
              border: `1px solid ${designTokens.colors.border.light}`,
            }}
          >
            <div className="flex items-center gap-3 mb-3">
              <div
                className="w-10 h-10 rounded-full flex items-center justify-center text-white font-bold"
                style={{
                  background: designTokens.colors.gradient.blue,
                }}
              >
                {selectedPlayer.lastName}
              </div>
              <div>
                <div className="font-bold text-lg">{selectedPlayer.name}</div>
                <div className="text-sm text-gray-600">
                  평균 {selectedPlayer.averageScore}타 · 핸디캡 {selectedPlayer.handicap}
                </div>
              </div>
            </div>
            
            <div className="grid grid-cols-2 gap-4 text-sm">
              <div>
                <div className="text-gray-600">현재 홀</div>
                <div className="font-bold">{selectedPlayer.currentHole || 1}홀</div>
              </div>
              <div>
                <div className="text-gray-600">현재 스코어</div>
                <div className="font-bold">{selectedPlayer.currentScore || 0}타</div>
              </div>
            </div>
            
            <motion.button
              className="absolute top-2 right-2 w-6 h-6 bg-gray-100 rounded-full flex items-center justify-center"
              onClick={() => setSelectedPlayer(null)}
              whileHover={{ scale: 1.1 }}
              whileTap={{ scale: 0.9 }}
            >
              ×
            </motion.button>
          </motion.div>
        )}
      </AnimatePresence>

      {/* 현재 홀 정보 */}
      <div className="absolute top-4 left-4 bg-white rounded-lg shadow-lg p-3 z-10">
        <div className="text-sm font-bold text-gray-800">
          {currentHole}홀 (파 {golfCourseHoles[currentHole - 1]?.par || 4})
        </div>
        <div className="text-xs text-gray-600">
          활성 플레이어: {players.filter(p => p.isPlaying).length}명
        </div>
      </div>
    </div>
  );
};

export default GolfCourseMap;
