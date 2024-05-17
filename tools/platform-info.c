#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#if __has_include(<TargetConditionals.h>)
    #include <TargetConditionals.h>
#endif

// Check OS
#if defined(_WIN32) || defined(_WIN64) || defined(__WIND32__) || defined(__TOS_WIN__) || defined(__WINDOWS__)
    #define TARGET_OS "Windows"
#elif defined(__CYGWIN__)
    #define TARGET_OS "Cygwin"
#elif defined(__linux__)
    #define TARGET_OS "Linux"
#elif defined(__APPLE__) && defined(__MACH__) && defined(macintosh) && defined(Macintosh)
    #if TARGET_IPHONE_SIMULATOR == 1 || TARGET_OS_IPHONE == 1
        #define TARGET_OS "iOS"
    #else /* TARGET_OS_MAC == 1 */
        #define TARGET_OS "MacOS"
    #endif
#elif defined(__bsdi__)
    #define TARGET_OS "BSDi BSD/OS"
#elif defined(__DragonFly__)
    #define TARGET_OS "DragonFly BSD"
#elif defined(__FreeBSD__)
    #define TARGET_OS "FreeBSD"
#elif defined(__NetBSD__)
    #define TARGET_OS "NetBSD"
#elif defined(__OpenBSD__)
    #define TARGET_OS "OpenBSD"
#elif defined(BSD) || defined(_SYSTYPE_BSD)
    #define TARGET_OS "BSD"
#elif defined(__HAIKU__)
    #define TARGET_OS "Haiku"
#elif defined(sgi) || defined(__sgi)
    #define TARGET_OS "IRIX"
#elif defined(hpux) || defined(_hpux) || defined(__hpux)
    #define TARGET_OS "HP-UX"
#elif defined(_AIX) || defined(__TOS_AIX__)
    #define TARGET_OS "AIX"
#elif defined(AMIGA) || defined(__amigaos__)
    #define TARGET_OS "AmigaOS"
#elif defined(__OS400__)
    #define TARGET_OS "OS400"
#elif defined(__QNX__)
    #define TARGET_OS "QNX"
#elif defined(VMS) || defined(__VMS)
    #define TARGET_OS "VMS"
#elif defined(__sysv__) || defined(__SVR4) || defined(__svr4__) || defined(_SYSTYPE_SVR4)
    #define TARGET_OS "SVR4"
#elif defined(sun) || defined(__sun)
    #define TARGET_OS "Solaris"
#elif defined(__BEOS__)
    #define TARGET_OS "BeOS"
#elif defined(unix) || defined(__unix)
    #define TARGET_OS "Unix"
#else
    #define TARGET_OS "unknown"
#endif

#ifndef WINAPI_FAMILY
#define WINAPI_FAMILY -1
#endif

// Check platform
#if defined(__ANDROID__)
    #define TARGET_PLATFORM "Android"
#elif defined(__CloudABI__)
    #define TARGET_PLATFORM "CloudABI"
#elif defined(TARGET_IPHONE_SIMULATOR) || defined(TARGET_OS_SIMULATOR)
    #define TARGET_PLATFORM "iOS Simulator"
#elif TARGET_OS_IPHONE == 1
    #define TARGET_PLATFORM "iOS"
#elif TARGET_OS_MAC == 1
    #define TARGET_PLATFORM "MacOS"
#elif defined(__MINGW64__)
    #define TARGET_PLATFORM "MinGW x64"
#elif defined(__MINGW32__)
    #define TARGET_PLATFORM "MinGW x32"
#elif defined(__MSYS__)
    #define TARGET_PLATFORM "MSYS"
#elif defined(__CYGWIN__)
    #define TARGET_PLATFORM "Cygwin"
#elif WINAPI_FAMILY == WINAPI_FAMILY_DESKTOP_APP
    #define TARGET_PLATFORM "Windows Desktop"
#elif WINAPI_FAMILY == WINAPI_FAMILY_PHONE_APP
    #define TARGET_PLATFORM "Windows Phone"
#elif WINAPI_FAMILY == WINAPI_FAMILY_SERVER
    #define TARGET_PLATFORM "Windows Server"
#elif WINAPI_FAMILY == WINAPI_FAMILY_PC_APP
    #define TARGET_PLATFORM "Windows PC App"
#elif WINAPI_FAMILY == WINAPI_FAMILY_SYSTEM
    #define TARGET_PLATFORM "Windows System"
#elif defined(_UWP)
    #define TARGET_PLATFORM "UWP"
#elif defined(__PROSPERO__)
    #define TARGET_PLATFORM "PS5"
#elif defined(__ORBIS__)
    #define TARGET_PLATFORM "PS4"
#elif defined(__CELLOS_LV2__)
    #define TARGET_PLATFORM "PS3"
#elif defined(__psp2__)
    #define TARGET_PLATFORM "PS Vita"
#elif _XBOX_VER >= 200
    #define TARGET_PLATFORM "XBOX 360"
#elif defined(_DURANGO)
    #define TARGET_PLATFORM "XBOX One"
#elif defined(__NX__)
    #define TARGET_PLATFORM "NX"
#else
    #define TARGET_PLATFORM "unknown"
#endif

// Check CPU architecture
#if defined(__alpha__) || defined(__alpha) || defined(_M_ALPHA)
    #define TARGET_ARCH "Alpha"
#elif defined(__arm64) || defined(_M_ARM64) || defined(__aarch64__) || defined(__AARCH64EL__)
    #define TARGET_ARCH "arm64"
#elif defined(__ARM_ARCH) || defined(__TARGET_ARCH_ARM) || defined(_M_ARM) || defined(__arm__) || defined(__ARM_ARCH_7__) || defined(__ARM_ARCH_7A__) || defined(__ARM_ARCH_7R__) || defined(__ARM_ARCH_7M__) || defined(__ARM_ARCH_6K__) || defined(__ARM_ARCH_6Z__) || defined(__ARM_ARCH_6KZ__) || defined(__ARM_ARCH_6T2__) || defined(__ARM_ARCH_5TE__) || defined(__ARM_ARCH_5TEJ__) || defined(__ARM_ARCH_4T__) || defined(__ARM_ARCH_4__) || defined(__ARM_ARCH_6K__) || defined(__ARM_ARCH_6Z__) || defined(__ARM_ARCH_6KZ__) || defined(__ARM_ARCH_6T2__) || defined(__ARM_ARCH_5TE__) || defined(__ARM_ARCH_5TEJ__) || defined(__ARM_ARCH_4T__) || defined(__ARM_ARCH_4__)
    #define TARGET_ARCH "arm"
#elif defined(__bfin__) || defined(__BFIN__) || defined(bfin) || defined(BFIN)
    #define TARGET_ARCH "Blackfin"
#elif defined(__convex__)
    #define TARGET_ARCH "Convex"
#elif defined(__e2k__)
    #define TARGET_ARCH "E2K"
#elif defined(__ia64__) || defined(_IA64) || defined(__IA64__) || defined(__ia64) || defined(_M_IA64) || defined(__itanium__)
    #define TARGET_ARCH "Itanium 64"
#elif defined(__m68k__) || defined(M68000)
    #define TARGET_ARCH "M68K"
#elif defined(__mips__) || defined(__mips) || defined(__MIPS__)
    #define TARGET_ARCH "MIPS"
#elif defined(__hppa__) || defined(__hppa) || defined(__HPPA__)
    #define TARGET_ARCH "HP/PA RISC"
#elif defined(__powerpc64__) || defined(__ppc64__) || defined(__PPC__) || defined(__PPC64__) || defined(_ARCH_PPC64)
    #define TARGET_ARCH "PowerPC 64x"
#elif defined(__powerpc) || defined(__powerpc__) || defined(__POWERPC__) || defined(__ppc__) || defined(__PPC__) || defined(_M_PPC) || defined(_ARCH_PPC) || defined(__PPCGECKO__) || defined(__PPCBROADWAY__) || defined(_XENON) || defined(__ppc)
    #define TARGET_ARCH "PowerPC 32x"
#elif defined(__CUDA_ARCH__)
    #define TARGET_ARCH "PTX"
#elif defined(pyr)
    #define TARGET_ARCH "Pyramid 9810"
#elif defined(__riscv)
    #define TARGET_ARCH "RISC-V"
#elif defined(__THW_RS6000) || defined(_IBMR2) || defined(_POWER) || defined(_ARCH_PWR) || defined(_ARCH_PWR2)
    #define TARGET_ARCH "RS6000"
#elif defined(__sparc__) || defined(__sparc)
    #define TARGET_ARCH "SPARC"
#elif defined(__sh__)
    #define TARGET_ARCH "SuperH"
#elif defined(__370__) || defined(__THW_370__)
    #define TARGET_ARCH "System/370"
#elif defined(__s390__) || defined(__s390x__)
    #define TARGET_ARCH "System/390"
#elif defined(__SYSC_ZARCH__)
    #define TARGET_ARCH "z/Architecture"
#elif defined(i386) || defined(__i386__) || defined(__i486__) || defined(__i586__) || defined(__i686__) || defined(__i386) || defined(_M_IX86) || defined(_X86_) || defined(__THW_INTEL__) || defined(__I86__) || defined(__INTEL__)
    #define TARGET_ARCH "x86"
#elif defined(__x86_64__) || defined(__x86_64) || defined(__amd64__) || defined(__amd64) || defined(_M_X64) || defined(_M_AMD64)
    #define TARGET_ARCH "x86_64"
#else
    #define TARGET_ARCH "unknown"
#endif

void print_usage(const char *prog_name) {
    printf("Usage: %s <[-h] | INFO>\n\n", prog_name);
    printf("OPTIONS:\n");
    printf("\t-h, --help        Show this help message and exit\n\n");
    
    printf("INFO is a format string containing following escapes:\n");
    printf("\t%%%%  Print a '%%' symbol\n");
    printf("\t%%a  Print target architecture\n");
    printf("\t%%s  Print target word size in bits\n");
    printf("\t%%o  Print target operating system\n");
    printf("\t%%p  Print target platform\n");
    printf("\t%%e  Print target endianness\n");
    exit(EXIT_SUCCESS);
}

bool is_little_endian() {
    volatile uint32_t i=0x01234567;
    // return 0 for big endian, 1 for little endian.
    return (*((uint8_t*)(&i))) == 0x67;
}

size_t word_size() {
    return sizeof(void*) * 8;
}

void print_format(const char *prog_name, FILE *stream, char c) {
    switch (c) {
        case 'a':
            fprintf(stream, TARGET_ARCH);
            break;
        case 's':
            fprintf(stream, "%d", word_size());
            break;
        case 'o':
            fprintf(stream, TARGET_OS);
            break;
        case 'p':
            fprintf(stream, TARGET_PLATFORM);
            break;
        case 'e':
            fprintf(stream, is_little_endian() ? "little" : "big");
            break;
        case '%':
            fprintf(stream, "%%");
            break;
        default:
            fprintf(stderr, "unknown format '%%%c'; see --help for details\n", c);
            fprintf(stream, "%%%c", c);
    }
}

int main(int argc, const char *argv[]) {
    if (argc < 2) {
        print_usage(argv[0]);
    }

    size_t i = 1;
    if (argv[i][0] != '-') {
        if (strcmp(argv[i] + 1, "h") == 0 || strcmp(argv[i] + 1, "-help") == 0) {
            print_usage(argv[0]);
            i++;
        }
    }

    FILE *stream = stdout;

    bool format_start = false;
    for(;i < argc; i++) {
        size_t curr_len = strlen(argv[i]);
        for(size_t j = 0; j < curr_len; j++) {
            char at = argv[i][j];
            if (at == '%') {
                if (j + 1 < curr_len) {
                    print_format(argv[0], stream, argv[i][++j]);
                } else {
                    format_start = true;
                }
            } else if (at == '\n') {
                fputc('\n', stream);
            }
            else if (at == '\\') {
                if (j + 1 < curr_len) {
                    at = argv[i][++j];
                    switch (at) {
                        case 'n':
                            fputc('\n', stream);
                            break;
                        case 't':
                            fputc('\t', stream);
                            break;
                        case '\\':
                            fputc('\\', stream);
                            break;
                        case '%':
                            fputc('%', stream);
                            break;
                        default:
                            fprintf(stderr, "unknown escape sequence '\\%c'\n", at);
                    }
                } else {
                    // fputc(' ', stream);
                    // default behavior
                }
            } else {
                printf("%c", at);
            }
        }
        if (i + 1 < argc) {
            if (format_start) {
                print_format(argv[0], stream, ' ');
            } else {
                fprintf(stream, " ");
            }
        }
    }
    fflush(stream);
    if (stream != stdout) {
        fclose(stream);
    }

    return EXIT_SUCCESS;
}
