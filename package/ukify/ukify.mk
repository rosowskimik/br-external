################################################################################
#
# ukify
#
################################################################################

UKIFY_VERSION = $(SYSTEMD_VERSION)
UKIFY_SITE = $(SYSTEMD_SITE)
UKIFY_SOURCE = systemd-$(UKIFY_VERSION).tar.gz

UKIFY_LICENSE = $(SYSTEMD_LICENSE)
UKIFY_LICENSE_FILES = $(SYSTEMD_LICENSE_FILES)

UKIFY_DL_SUBDIR = systemd

UKIFY_INSTALL_STAGING = NO
UKIFY_INSTALL_TARGET = NO
UKIFY_INSTALL_IMAGES = NO

HOST_UKIFY_DEPENDENCIES = \
	$(BR2_COREUTILS_HOST_DEPENDENCY) \
	host-util-linux \
	host-patchelf \
	host-libcap \
	host-libxcrypt \
	host-gperf \
	host-python-jinja2 \
	host-python-pefile

HOST_UKIFY_CONF_OPTS = \
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
	-Dbootloader=disabled \
	-Defi=false \
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
	-Dcreate-log-dirs=false \
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
	-Dtmpfiles=true \
	-Dimportd=disabled \
	-Dhwdb=true \
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
	-Dukify=enabled \
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

HOST_UKIFY_NINJA_ENV = DESTDIR=$(HOST_DIR)

$(eval $(host-meson-package))
