# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# go mod vendor && grep "# g" ./vendor/modules.txt | sort
EGO_PN="github.com/bettercap/bettercap"
EGO_VENDOR=(
	"github.com/acarl005/stripansi 5a71ef0e047d"
	"github.com/adrianmo/go-nmea v1.3.0"
	"github.com/antchfx/jsonquery v1.1.4"
	"github.com/antchfx/xpath v1.1.10"
	"github.com/bettercap/gatt 569d3d9372bb"
	"github.com/bettercap/nrf24 aa37e6d0e0eb"
	"github.com/bettercap/readline 655e48bcb7bf"
	"github.com/bettercap/recording 3ce1dcf032e3"
	"github.com/chifflier/nfqueue-go 61ca646babef"
	"github.com/dustin/go-humanize v1.0.0"
	"github.com/elazarl/goproxy 0581fc3aee2d"
	"github.com/evilsocket/islazy v1.10.6"
	"github.com/gobwas/glob e7a84e9525fe"
	"github.com/golang/groupcache 8c9f03a8e57e"
	"github.com/google/go-github v17.0.0"
	"github.com/google/gopacket v1.1.18"
	"github.com/google/go-querystring v1.0.0"
	"github.com/google/gousb v2.1.0"
	"github.com/gorilla/mux v1.8.0"
	"github.com/gorilla/websocket v1.4.2"
	"github.com/hashicorp/mdns v1.0.3"
	"github.com/inconshreveable/go-vhost 06d84117953b"
	"github.com/jpillora/go-tld v1.0.0"
	"github.com/koppacetic/go-gpsd v0.4.0"
	"github.com/kr/binarydist v0.1.0"
	"github.com/malfunkt/iprange v0.9.0"
	"github.com/mattn/go-colorable v0.1.7"
	"github.com/mattn/go-isatty v0.0.12"
	"github.com/mdlayher/dhcp6 2a67805d7d0b"
	"github.com/mgutz/ansi d51e80ef957d"
	"github.com/mgutz/logxi aebf8a7d67ab"
	"github.com/miekg/dns v1.1.31"
	"github.com/mitchellh/go-homedir v1.1.0"
	"github.com/pkg/errors v0.9.1"
	"github.com/robertkrimen/otto ef014fd054ac"
	"github.com/tarm/serial 98f6abe2eb07"
	"github.com/thoj/go-ircevent 8e7ce4b5a1eb"
	"golang.org/x/crypto 5c72a883971a github.com/golang/crypto"
	"golang.org/x/net 05aa5d4ee321 github.com/golang/net"
	"golang.org/x/sys 479acdf4ea46 github.com/golang/sys"
	"golang.org/x/text v0.3.3 github.com/golang/text"
#	"gopkg.in/sourcemap.v1 v1.0.5 github.com/go-sourcemap/sourcemap"
)

inherit golang-vcs-snapshot

DESCRIPTION="A complete, modular, portable and easily extensible MITM framework"
HOMEPAGE="https://github.com/bettercap/bettercap/"

SRC_URI="https://github.com/bettercap/bettercap/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_VENDOR_URI}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RESTRICT="mirror"

RDEPEND="
	net-libs/libpcap
	net-libs/libnetfilter_queue
	net-libs/libnfnetlink
	virtual/libusb:*"
DEPEND="${RDEPEND}
	=dev-go/gopkg-sourcemap-1*
	"

BDEPEND="virtual/pkgconfig"

src_compile() {
	GOPATH="${S}:$(get_golibdir_gopath)" \
		GOCACHE="${T}/go-cache" \
		go build -v -work -x -ldflags="-s -w" ./... "${EGO_PN}" || die
}

src_install() {
	GOPATH="${S}:$(get_golibdir_gopath)" \
		GOCACHE="${T}/go-cache" \
		go install -v -work -x -ldflags="-s -w" ./... "${EGO_PN}" || die

	dosbin bin/bettercap
	dodoc "src/${EGO_PN}"/{{README,ISSUE_TEMPLATE}.md,Dockerfile}
}
