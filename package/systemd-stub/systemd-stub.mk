################################################################################
#
# systemd-stub
#
################################################################################

SYSTEMD_STUB_VERSION = $(SYSTEMD_VERSION)
SYSTEMD_STUB_SITE = $(SYSTEMD_SITE)
SYSTEMD_STUB_SOURCE = systemd-$(SYSTEMD_STUB_VERSION).tar.gz

SYSTEMD_STUB_LICENSE = $(SYSTEMD_LICENSE)
SYSTEMD_STUB_LICENSE_FILES = $(SYSTEMD_LICENSE_FILES)

SYSTEMD_STUB_DL_SUBDIR = systemd

SYSTEMD_STUB_INSTALL_STAGING = NO
SYSTEMD_STUB_INSTALL_TARGET = NO
SYSTEMD_STUB_INSTALL_IMAGES = YES

SYSTEMD_STUB_DEPENDENCIES = \
	$(BR2_COREUTILS_HOST_DEPENDENCY) \
	host-python-jinja2 \
	host-python-pyelftools \
	gnu-efi \
	libcap \
	libxcrypt \
	util-linux

SYSTEMD_STUB_CONF_ENV = $(HOST_UTF8_LOCALE_ENV)
SYSTEMD_STUB_NINJA_ENV = $(HOST_UTF8_LOCALE_ENV)

SYSTEMD_STUB_CONF_OPTS = \
	-Dsplit-bin=true \
	--prefix=/usr \
	--libdir=lib \
	--sysconfdir=/etc \
	--localstatedir=/var \
	-Dcreate-log-dirs=false \
	-Dvcs-tag=false \
	-Dmode=release \
	-Dutmp=false \
	-Dhibernate=false \
	-Dtpm2=disabled \
	-Dldconfig=false \
	-Dresolve=false \
	-Dbootloader=enabled \
	-Defi=true \
	-Dtpm=false \
	-Denvironment-d=false \
	-Dbinfmt=false \
	-Drepart=disabled \
	-Dcoredump=false \
	-Ddbus=disabled \
	-Ddbus-interfaces-dir=no \
	-Dpstore=false \
	-Doomd=false \
	-Dlogind=false \
	-Dhostnamed=false \
	-Dlocaled=false \
	-Dmachined=false \
	-Dpasswdqc=disabled \
	-Dportabled=false \
	-Dsysext=false \
	-Dsysupdate=disabled \
	-Dmountfsd=false \
	-Duserdb=false \
	-Dhomed=disabled \
	-Dnetworkd=false \
	-Dtimedated=false \
	-Dtimesyncd=false \
	-Dremote=disabled \
	-Dnsresourced=false \
	-Dnss-myhostname=false \
	-Dnss-mymachines=disabled \
	-Dnss-resolve=disabled \
	-Dnss-systemd=false \
	-Dfirstboot=false \
	-Drandomseed=false \
	-Dbacklight=false \
	-Dvconsole=false \
	-Dvmspawn=disabled \
	-Dquotacheck=false \
	-Dsysusers=false \
	-Dstoragetm=false \
	-Dtmpfiles=false \
	-Dimportd=disabled \
	-Dhwdb=false \
	-Drfkill=false \
	-Dman=disabled \
	-Dhtml=disabled \
	-Dsmack=false \
	-Dpolkit=disabled \
	-Dblkid=disabled \
	-Didn=false \
	-Dadm-group=false \
	-Dwheel-group=false \
	-Dzlib=disabled \
	-Dgshadow=false \
	-Dima=false \
	-Dtests=false \
	-Dfuzz-tests=false \
	-Dinstall-tests=false \
	-Dlog-message-verification=disabled \
	-Dglib=disabled \
	-Dlibarchive=disabled \
	-Dacl=disabled \
	-Dsysvinit-path='' \
	-Dinitrd=false \
	-Dxdg-autostart=false \
	-Dkernel-install=false \
	-Dukify=disabled \
	-Danalyze=false \
	-Dbpf-framework=disabled \
	-Dvmlinux-h=disabled \
	-Dpwquality=disabled \
	-Dmicrohttpd=disabled \
	-Dqrencode=disabled \
	-Dselinux=disabled \
	-Dlibcryptsetup=disabled \
	-Dlibcryptsetup-plugins=disabled \
	-Delfutils=disabled \
	-Dlibiptc=disabled \
	-Dapparmor=disabled \
	-Daudit=disabled \
	-Dxenctrl=disabled \
	-Dlibidn2=disabled \
	-Dlibidn=disabled \
	-Dseccomp=disabled \
	-Dxkbcommon=disabled \
	-Dbzip2=disabled \
	-Dzstd=disabled \
	-Dlz4=disabled \
	-Dpam=disabled \
	-Dfdisk=disabled \
	-Dkmod=disabled \
	-Dxz=disabled \
	-Dlibcurl=disabled \
	-Dgcrypt=disabled \
	-Dgnutls=disabled \
	-Dopenssl=disabled \
	-Dp11kit=disabled \
	-Dlibfido2=disabled \
	-Dpcre2=disabled \
	-Dsysupdated=disabled

SYSTEMD_STUB_EFI_ARCH = $(call qstrip,$(BR2_PACKAGE_SYSTEMD_STUB_EFI_ARCH))

define SYSTEMD_STUB_INSTALL_IMAGES_CMDS
	$(INSTALL) -D -m 0644 \
		$(@D)/buildroot-build/src/boot/linux$(SYSTEMD_STUB_EFI_ARCH).efi.stub \
		$(BINARIES_DIR)/sd-stub.efi
endef

$(eval $(meson-package))
