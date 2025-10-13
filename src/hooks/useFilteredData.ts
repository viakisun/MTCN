import { useState, useMemo } from 'react';

export interface FilterOption {
  id: string;
  label: string;
  icon: string;
  count: number;
}

interface FilterConfig<T> {
  items: T[];
  filterFn: (item: T, filterId: string) => boolean;
  searchFields: (item: T) => string[];
  filterOptions: (items: T[]) => FilterOption[];
}

interface UseFilteredDataReturn<T> {
  filteredItems: T[];
  activeFilter: string;
  setActiveFilter: (filter: string) => void;
  searchQuery: string;
  setSearchQuery: (query: string) => void;
  filterOptions: FilterOption[];
  hasFilters: boolean;
}

/**
 * useFilteredData - Generic hook for filtering data
 * Provides consistent filter and search logic across pages
 *
 * @param config - Filter configuration object
 * @returns Filtered items and filter controls
 *
 * @example
 * const { filteredItems, activeFilter, setActiveFilter, searchQuery, setSearchQuery, filterOptions } = useFilteredData({
 *   items: roundings,
 *   filterFn: (rounding, filterId) => filterId === 'all' || rounding.status === filterId,
 *   searchFields: (rounding) => [rounding.courseName, rounding.eventName],
 *   filterOptions: (items) => [
 *     { id: 'all', label: '전체', icon: 'filter', count: items.length },
 *     { id: 'upcoming', label: '예정', icon: 'calendar', count: items.filter(r => r.status === 'upcoming').length }
 *   ]
 * });
 */
export const useFilteredData = <T>({
  items,
  filterFn,
  searchFields,
  filterOptions: generateFilterOptions
}: FilterConfig<T>): UseFilteredDataReturn<T> => {
  const [activeFilter, setActiveFilter] = useState('all');
  const [searchQuery, setSearchQuery] = useState('');

  // Generate filter options based on current items
  const filterOptions = useMemo(() => {
    return generateFilterOptions(items);
  }, [items, generateFilterOptions]);

  // Filter and search items
  const filteredItems = useMemo(() => {
    let filtered = items;

    // Apply filter
    if (activeFilter !== 'all') {
      filtered = filtered.filter(item => filterFn(item, activeFilter));
    }

    // Apply search
    if (searchQuery.trim()) {
      const query = searchQuery.toLowerCase();
      filtered = filtered.filter(item =>
        searchFields(item).some(field =>
          field.toLowerCase().includes(query)
        )
      );
    }

    return filtered;
  }, [items, activeFilter, searchQuery, filterFn, searchFields]);

  const hasFilters = activeFilter !== 'all' || searchQuery.trim() !== '';

  return {
    filteredItems,
    activeFilter,
    setActiveFilter,
    searchQuery,
    setSearchQuery,
    filterOptions,
    hasFilters
  };
};

export default useFilteredData;
