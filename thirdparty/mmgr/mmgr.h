// ---------------------------------------------------------------------------------------------------------------------------------
//                                     _
//                                    | |
//  _ __ ___  _ __ ___   __ _ _ __    | |__
// | '_ ` _ \| '_ ` _ \ / _` | '__|   | '_ \ 
// | | | | | | | | | | | (_| | |    _ | | | |
// |_| |_| |_|_| |_| |_|\__, |_|   (_)|_| |_|
//                       __/ |
//                      |___/
//
// Memory manager & tracking software
//
// Best viewed with 8-character tabs and (at least) 132 columns
//
// ---------------------------------------------------------------------------------------------------------------------------------
//
// Restrictions & freedoms pertaining to usage and redistribution of this software:
//
//  * This software is 100% free
//  * If you use this software (in part or in whole) you must credit the author.
//  * This software may not be re-distributed (in part or in whole) in a modified
//    form without clear documentation on how to obtain a copy of the original work.
//  * You may not use this software to directly or indirectly cause harm to others.
//  * This software is provided as-is and without warrantee. Use at your own risk.
//
// For more information, visit HTTP://www.FluidStudios.com
//
// ---------------------------------------------------------------------------------------------------------------------------------
// Originally created on 12/22/2000 by Paul Nettle
//
// Copyright 2000, Fluid Studios, Inc., all rights reserved.
// ---------------------------------------------------------------------------------------------------------------------------------

#ifndef _H_MMGR
#define _H_MMGR

#include <cstdint>
#include <cstdlib>

// ---------------------------------------------------------------------------------------------------------------------------------
// For systems that don't have the __FUNCTION__ variable, we can just define it here
// ---------------------------------------------------------------------------------------------------------------------------------

#define __FUNCTION__ "??"

// ---------------------------------------------------------------------------------------------------------------------------------
// Types
// ---------------------------------------------------------------------------------------------------------------------------------

enum class alloc_type : unsigned int {
  m_unknown = 0,
  m_new = 1,
  m_new_array = 2,
  m_malloc = 3,
  m_calloc = 4,
  m_realloc = 5,
  m_delete = 6,
  m_delete_array = 7,
  m_free = 8,
};

typedef struct tag_au
{
  size_t actualSize;
  size_t reportedSize;
  void *actualAddress;
  void *reportedAddress;
  char sourceFile[40];
  char sourceFunc[40];
  size_t sourceLine;
  alloc_type allocationType;
  bool breakOnDealloc;
  bool breakOnRealloc;
  unsigned int allocationNumber;
  struct tag_au *next;
  struct tag_au *prev;
} sAllocUnit;

typedef struct
{
  uintptr_t totalReportedMemory;
  uintptr_t totalActualMemory;
  uintptr_t peakReportedMemory;
  uintptr_t peakActualMemory;
  uintptr_t accumulatedReportedMemory;
  uintptr_t accumulatedActualMemory;
  uintptr_t accumulatedAllocUnitCount;
  size_t totalAllocUnitCount;
  uintptr_t peakAllocUnitCount;
} sMStats;

// ---------------------------------------------------------------------------------------------------------------------------------
// Used by the macros
// ---------------------------------------------------------------------------------------------------------------------------------

void m_setOwner(const char *file, const size_t line, const char *func);

// ---------------------------------------------------------------------------------------------------------------------------------
// Allocation breakpoints
// ---------------------------------------------------------------------------------------------------------------------------------

bool &m_breakOnRealloc(void *reportedAddress);
bool &m_breakOnDealloc(void *reportedAddress);

// ---------------------------------------------------------------------------------------------------------------------------------
// The meat of the memory tracking software
// ---------------------------------------------------------------------------------------------------------------------------------

void *m_allocator(const char *sourceFile,
  const size_t sourceLine,
  const char *sourceFunc,
  const alloc_type allocationType,
  const size_t reportedSize);
void *m_reallocator(const char *sourceFile,
  const size_t sourceLine,
  const char *sourceFunc,
  const alloc_type reallocationType,
  const size_t reportedSize,
  void *reportedAddress);
void m_deallocator(const char *sourceFile,
  const size_t sourceLine,
  const char *sourceFunc,
  const alloc_type deallocationType,
  const void *reportedAddress);

// ---------------------------------------------------------------------------------------------------------------------------------
// Utilitarian functions
// ---------------------------------------------------------------------------------------------------------------------------------

bool m_validateAddress(const void *reportedAddress);
bool m_validateAllocUnit(const sAllocUnit *allocUnit);
bool m_validateAllAllocUnits();

// ---------------------------------------------------------------------------------------------------------------------------------
// Unused RAM calculations
// ---------------------------------------------------------------------------------------------------------------------------------

size_t m_calcUnused(const sAllocUnit *allocUnit);
size_t m_calcAllUnused();

// ---------------------------------------------------------------------------------------------------------------------------------
// Logging and reporting
// ---------------------------------------------------------------------------------------------------------------------------------

void m_dumpAllocUnit(const sAllocUnit *allocUnit, const char *prefix = "");
void m_dumpMemoryReport(const char *filename = "memreport.log", const bool overwrite = true);
sMStats m_getMemoryStatistics();

// ---------------------------------------------------------------------------------------------------------------------------------
// Variations of global operators new & delete
// ---------------------------------------------------------------------------------------------------------------------------------

#ifdef IS_MMGR_ENABLED
void *operator new(size_t reportedSize);
void *operator new[](size_t reportedSize);
void *operator new(size_t reportedSize, const char *sourceFile, size_t sourceLine);
void *operator new[](size_t reportedSize, const char *sourceFile, size_t sourceLine);
void operator delete(void *reportedAddress);
void operator delete[](void *reportedAddress);
#endif

#endif// _H_MMGR

// ---------------------------------------------------------------------------------------------------------------------------------
// Macros -- "Kids, please don't try this at home. We're trained professionals here." :)
// ---------------------------------------------------------------------------------------------------------------------------------

#ifdef IS_MMGR_ENABLED
#include "nommgr.h"
#define new (m_setOwner(__FILE__, __LINE__, __FUNCTION__), false) ? NULL : new
#define delete (m_setOwner(__FILE__, __LINE__, __FUNCTION__), false) ? m_setOwner("", 0, "") : delete
#define malloc(sz) m_allocator(__FILE__, __LINE__, __FUNCTION__, alloc_type::m_malloc, sz)
#define calloc(sz) m_allocator(__FILE__, __LINE__, __FUNCTION__, alloc_type::m_calloc, sz)
#define realloc(ptr, sz) m_reallocator(__FILE__, __LINE__, __FUNCTION__, alloc_type::m_realloc, sz, ptr)
#define free(ptr) m_deallocator(__FILE__, __LINE__, __FUNCTION__, alloc_type::m_free, ptr)
#endif
