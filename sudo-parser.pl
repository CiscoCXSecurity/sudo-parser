#!/usr/bin/perl -w
# Copyright (c) 2020, Cisco International Ltd
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the Cisco International Ltd nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL CISCO INTERNATIONAL LTD BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

use strict;

use File::Basename;
use Getopt::Std;
use Cwd;
use Data::Dumper;

my @bannedlist = (
	".*ALL.*",
	".*\/tmp.*",
	".*\/home.*",
	".*\/etc.*",
	".*\/egrep.*",
	".*\/rm.*",
	".*\/mkdir.*",
	".*\/useradd.*",
	".*\/adduser.*",
	".*\/mkuser.*",
	".*\/usermod.*",
	".*\/chuser.*",
	".*passwd.*",
	".*shadow.*",
	".*\/apt-get.*",
	".*\/apt.*",
	".*\/ar.*",
	".*\/aria2c.*",
	".*\/arp.*",
	".*\/ash.*",
	".*\/at.*",
	".*\/atobm.*",
	".*\/awk.*",
	".*\/base32.*",
	".*\/base64.*",
	".*\/basenc.*",
	".*\/bash.*",
	".*\/bpftrace.*",
	".*\/bridge.*",
	".*\/bundler.*",
	".*\/busctl.*",
	".*\/busybox.*",
	".*\/byebug.*",
	".*\/cancel.*",
	".*\/capsh.*",
	".*\/cat.*",
	".*\/check_by_ssh.*",
	".*\/check_cups.*",
	".*\/check_log.*",
	".*\/check_memory.*",
	".*\/check_raid.*",
	".*\/check_ssl_cert.*",
	".*\/check_statusfile.*",
	".*\/chmod.*",
	".*\/chown.*",
	".*\/chroot.*",
	".*\/cobc.*",
	".*\/column.*",
	".*\/comm.*",
	".*\/composer.*",
	".*\/cowsay.*",
	".*\/cowthink.*",
	".*\/cp.*",
	".*\/cpan.*",
	".*\/cpulimit.*",
	".*\/crash.*",
	".*\/crontab.*",
	".*\/csh.*",
	".*\/csplit.*",
	".*\/cupsfilter.*",
	".*\/curl.*",
	".*\/cut.*",
	".*\/dash.*",
	".*\/date.*",
	".*\/dd.*",
	".*\/dialog.*",
	".*\/diff.*",
	".*\/dig.*",
	".*\/dmesg.*",
	".*\/dmsetup.*",
	".*\/dnf.*",
	".*\/docker.*",
	".*\/dpkg.*",
	".*\/easy_install.*",
	".*\/eb.*",
	".*\/ed.*",
	".*\/emacs.*",
	".*\/env.*",
	".*\/eqn.*",
	".*\/ex.*",
	".*\/exiftool.*",
	".*\/expand.*",
	".*\/expect.*",
	".*\/facter.*",
	".*\/file.*",
	".*\/find.*",
	".*\/finger.*",
	".*\/flock.*",
	".*\/fmt.*",
	".*\/fold.*",
	".*\/ftp.*",
	".*\/gawk.*",
	".*\/gcc.*",
	".*\/gdb.*",
	".*\/gem.*",
	".*\/genisoimage.*",
	".*\/ghc.*",
	".*\/ghci.*",
	".*\/gimp.*",
	".*\/git.*",
	".*\/grep.*",
	".*\/gtester.*",
	".*\/hd.*",
	".*\/head.*",
	".*\/hexdump.*",
	".*\/highlight.*",
	".*\/hping3.*",
	".*\/iconv.*",
	".*\/iftop.*",
	".*\/install.*",
	".*\/ionice.*",
	".*\/ip.*",
	".*\/irb.*",
	".*\/jjs.*",
	".*\/join.*",
	".*\/journalctl.*",
	".*\/jq.*",
	".*\/jrunscript.*",
	".*\/ksh.*",
	".*\/ksshell.*",
	".*\/ld.so.*",
	".*\/ldconfig.*",
	".*\/less.*",
	".*\/logsave.*",
	".*\/look.*",
	".*\/ltrace.*",
	".*\/lua.*",
	".*\/lwp-download.*",
	".*\/lwp-request.*",
	".*\/mail.*",
	".*\/make.*",
	".*\/man.*",
	".*\/mawk.*",
	".*\/more.*",
	".*\/mount.*",
	".*\/mtr.*",
	".*\/mv.*",
	".*\/mysql.*",
	".*\/nano.*",
	".*\/nawk.*",
	".*\/nc.*",
	".*\/nice.*",
	".*\/nl.*",
	".*\/nmap.*",
	".*\/node.*",
	".*\/nohup.*",
	".*\/npm.*",
	".*\/nroff.*",
	".*\/nsenter.*",
	".*\/od.*",
	".*\/openssl.*",
	".*\/openvt.*",
	".*\/paste.*",
	".*\/pdb.*",
	".*\/perl.*",
	".*\/pg.*",
	".*\/php.*",
	".*\/pic.*",
	".*\/pico.*",
	".*\/pip.*",
	".*\/pkexec.*",
	".*\/pr.*",
	".*\/pry.*",
	".*\/psql.*",
	".*\/puppet.*",
	".*\/python.*",
	".*\/rake.*",
	".*\/readelf.*",
	".*\/red.*",
	".*\/redcarpet.*",
	".*\/restic.*",
	".*\/rev.*",
	".*\/rlogin.*",
	".*\/rlwrap.*",
	".*\/rpm.*",
	".*\/rpmquery.*",
	".*\/rsync.*",
	".*\/ruby.*",
	".*\/run-mailcap.*",
	".*\/run-parts.*",
	".*\/rview.*",
	".*\/rvim.*",
	".*\/scp.*",
	".*\/screen.*",
	".*\/script.*",
	".*\/sed.*",
	".*\/service.*",
	".*\/setarch.*",
	".*\/sftp.*",
	".*\/shuf.*",
	".*\/slsh.*",
	".*\/smbclient.*",
	".*\/socat.*",
	".*\/soelim.*",
	".*\/sort.*",
	".*\/split.*",
	".*\/sqlite3.*",
	".*\/ss.*",
	".*\/ssh-keyscan.*",
	".*\/ssh.*",
	".*\/start-stop-daemon.*",
	".*\/stdbuf.*",
	".*\/strace.*",
	".*\/strings.*",
	".*\/su.*",
	".*\/sysctl.*",
	".*\/systemctl.*",
	".*\/tac.*",
	".*\/tail.*",
	".*\/tar.*",
	".*\/taskset.*",
	".*\/tbl.*",
	".*\/tclsh.*",
	".*\/tcpdump.*",
	".*\/tee.*",
	".*\/telnet.*",
	".*\/tftp.*",
	".*\/time.*",
	".*\/timeout.*",
	".*\/tmux.*",
	".*\/top.*",
	".*\/troff.*",
	".*\/ul.*",
	".*\/unexpand.*",
	".*\/uniq.*",
	".*\/unshare.*",
	".*\/update-alternatives.*",
	".*\/uudecode.*",
	".*\/uuencode.*",
	".*\/valgrind.*",
	".*\/vi.*",
	".*\/view.*",
	".*\/vigr.*",
	".*\/vim.*",
	".*\/vimdiff.*",
	".*\/vipw.*",
	".*\/watch.*",
	".*\/wget.*",
	".*\/whois.*",
	".*\/wish.*",
	".*\/xargs.*",
	".*\/xmodmap.*",
	".*\/xxd.*",
	".*\/xz.*",
	".*\/yelp.*",
	".*\/yum.*",
	".*\/zip.*",
	".*\/zsh.*",
	".*\/zsoelim.*",
	".*\/zypper.*",
);


my %commandaliases;
my %useraliases;
my %allowedlist;
my $usernameorgroupname;
my $realusernameorgroupname;
my $commandname;
my $realcommandname;
my $bannedcommandname;
my $filename;

sub resolveCommandnames {
	my $commandnameslist;
	my $realcommandnameslist;
	my $commandname;
	my $notflag;
	my $resolvedcommandnameslist;
	my $realcommandname;
	$commandnameslist = shift;
	$realcommandnameslist = ();
	for $commandname (split(/,/, $commandnameslist)) {
		if ($commandname =~ /\s*?\([^\s]+\)\s*?([^\s]+)/) {
			$commandname = $1;
		}
		if ($commandname =~ /\s*?([^\s]+)/) {
			$commandname = $1;
		}
		$notflag = 0;
		if ($commandname =~ /!(.*)/) {
			$notflag = 1;
			$commandname = $1;
		}
		if (defined($commandaliases{$commandname}) || defined($commandaliases{"!" . $commandname})) {
			foreach $resolvedcommandnameslist (resolveCommandnames(join(",", @{$commandaliases{$commandname}}))) {
				foreach $realcommandname (@{$resolvedcommandnameslist}) {
					push(@{$realcommandnameslist}, ($notflag == 1) ? "!" . $realcommandname : $realcommandname);
				}
			}
		} else {
			push(@{$realcommandnameslist}, ($notflag == 1) ? "!" . $commandname : $commandname);
		}
	}
	return $realcommandnameslist;
}

sub resolveUsernamesAndGroupnames {
	my $usernamesandgroupnameslist;
	my $realusernamesandgroupnameslist;
	my $usernameorgroupname;
	my $resolvedusernamesorgroupnameslist;
	my $realusernameorgroupname;
	$usernamesandgroupnameslist = shift;
	$realusernamesandgroupnameslist = ();
	for $usernameorgroupname (split(/,/, $usernamesandgroupnameslist)) {
		if ($usernameorgroupname =~ /\s*?([^\s]+)\s*?/) {
			$usernameorgroupname = $1;
		}
		if (defined($useraliases{$usernameorgroupname})) {
			foreach $resolvedusernamesorgroupnameslist (resolveUsernamesAndGroupnames(join(",", @{$useraliases{$usernameorgroupname}}))) {
				foreach $realusernameorgroupname (@{$resolvedusernamesorgroupnameslist}) {
					push(@{$realusernamesandgroupnameslist}, $realusernameorgroupname);
				}
			}
		} else {
			if ($usernameorgroupname =~ /^%[A-Za-z0-9_,]+/) {
				push(@{$realusernamesandgroupnameslist}, $usernameorgroupname);
			} else {
				push(@{$realusernamesandgroupnameslist}, $usernameorgroupname);
			}
		}
	}
	return $realusernamesandgroupnameslist;
}

sub parse {
	my $filename;
	my $filehandle;
	my $aliasname;
	my $usernameslist;
	my $commandname;
	my $usernameorgroupname;
	my $commandnameslist;
	my $realcommandname;
	my $groupnameslist;
	my $realgroupname;
	my $realusername;
	my $includefilename;
	$filename = shift;
	open($filehandle, "<" . $filename);
	while (<$filehandle>) {
		while ($_ =~ /(.*?)\\$/) {
			$_ = $1 . <$filehandle>;
		}
		$_ =~ s/\x0a//g;
		$_ =~ s/\x0d//g;
		if ($_ !~ /^$/) {
			if ($_ !~ /^#/) {
				$_ =~ s/#.*//g;
				if ($_ =~ /^Defaults/) {
					print "I: parse defaults\n";
				} else {
					if ($_ =~ /Host_Alias\s+([A-Za-z0-9_]+?)\s*=(.*)/) {
						print "I: parse host alias\n";
					} else {
						if ($_ =~ /User_Alias\s+([A-Za-z0-9_]+?)\s*=(.*)/) {
							$aliasname = $1;
							$usernameslist = $2;
							if ($aliasname =~ /\s*?([^\s]+)\s*?/) {
								$aliasname = $1;
							}
							if (!defined($useraliases{$aliasname})) {
								$useraliases{$aliasname} = ()
							}
							foreach $usernameorgroupname (@{resolveUsernamesAndGroupnames($usernameslist)}) {
								push(@{$useraliases{$aliasname}}, $usernameorgroupname);
							}
						} else {
							if ($_ =~ /^Cmnd_Alias\s+([A-Za-z0-9_]+?)\s*=(.*)/) {
								$aliasname = $1;
								$commandnameslist = $2;
								if ($aliasname =~ /\s*?([^\s]+)\s*?/) {
									$aliasname = $1;
								}
								if (!defined($commandaliases{$aliasname})) {
									$commandaliases{$aliasname} = ()
								}
								foreach $realcommandname (@{resolveCommandnames($commandnameslist)}) {
									push(@{$commandaliases{$aliasname}}, $realcommandname);
								}
							} else {
								if ($_ =~ /^(%[A-Za-z0-9_,]+)\s*?.*?\s*?=(.*)/) {
									$groupnameslist = $1;
									$commandnameslist = $2;
									if ($commandnameslist =~ /.*?:(.*)/) {
										$commandnameslist = $1;
									}
									foreach $realgroupname (@{resolveUsernamesAndGroupnames($groupnameslist)}) {
										if (!defined($allowedlist{$realgroupname})) {
											$allowedlist{$realgroupname} = ();
										}
										foreach $realcommandname (@{resolveCommandnames($commandnameslist)}) {
											push(@{$allowedlist{$realgroupname}}, $realcommandname);
										}
									}
								} else {
									if ($_ =~ /^([A-Za-z0-9_,]+)\s*?.*?\s*?=(.*)/) {
										$usernameslist = $1;
										$commandnameslist = $2;
										if ($commandnameslist =~ /.*?:(.*)/) {
											$commandnameslist = $1;
										}
										foreach $realusername (@{resolveUsernamesAndGroupnames($usernameslist)}) {
											if (!defined($allowedlist{$realusername})) {
												$allowedlist{$realusername} = ();
											}
											foreach $realcommandname (@{resolveCommandnames($commandnameslist)}) {
												push(@{$allowedlist{$realusername}}, $realcommandname);
											}
										}
									} else {
										print "W: unknown: " . $_ . "\n";
									}
								}
							}
						}
					}
				}
			} else {
				if ($_ =~ /^#include (.*)/) {
					print "I: parsing " . $1 . "\n";
					parse($1);
				} else {
					if ($_ =~ /^#includedir (.*)/) {
						print "I: parsing " . $1 . "\n";
						foreach $includefilename (glob($1 . "/*")) {
							parse($includefilename);
						}
					}
				}
			}
		}
	}
}

sub main::HELP_MESSAGE {
	die "usage: " . basename($0) . " <filename>";
}

sub main::VERSION_MESSAGE {
	print basename($0) . " 1.0\n";
}

$filename = shift;

if (defined($filename)) {
	if (! -e $filename) {
		Getopt::Std::help_mess("", "main");
	}
} else {
	Getopt::Std::help_mess("", "main");
}

parse($filename);
foreach $usernameorgroupname (keys %allowedlist) {
	if (defined($useraliases{$usernameorgroupname})) {
		foreach $realusernameorgroupname (@{resolveUsernamesAndGroupnames(join(",", @{$useraliases{$usernameorgroupname}}))}) {
			foreach $commandname (@{$allowedlist{$realusernameorgroupname}}) {
				if (defined($commandaliases{$commandname})) {
					foreach $realcommandname (@{resolveCommandnames($commandname)}) {
						foreach $bannedcommandname (@bannedlist) {
							if ($realcommandname =~ /$bannedcommandname/) {
								print "E: " . $realusernameorgroupname . ":" . $realcommandname . " matches " . $bannedcommandname . "\n";
								print "W: " . $usernameorgroupname . " (" . $realusernameorgroupname . ") wasn't defined when " . $realcommandname . " was allowed\n";
								print "W: " . $commandname . " (" . $realcommandname . ") wasn't defined when " . $realusernameorgroupname . " was allowed\n";
							}
						}
					}
				} else {
					foreach $bannedcommandname (@bannedlist) {
						if ($commandname =~ /$bannedcommandname/) {
							print "E: " . $realusernameorgroupname . ":" . $commandname . " matches " . $bannedcommandname . "\n";
							print "W: " . $usernameorgroupname . " (" . $realusernameorgroupname . ") wasn't defined when " . $commandname . " was allowed\n";
						}
					}
				}
			}
		}
	} else {
		foreach $commandname (@{$allowedlist{$usernameorgroupname}}) {
			if (defined($commandaliases{$commandname})) {
				foreach $realcommandname (@{resolveCommandnames($commandname)}) {
					foreach $bannedcommandname (@bannedlist) {
						if ($realcommandname =~ /$bannedcommandname/) {
							print "E: " . $usernameorgroupname . ":" . $realcommandname . " matches " . $bannedcommandname . "\n";
							print "W: " . $commandname . " (" . $realcommandname . ") wasn't defined when " . $usernameorgroupname . " was allowed\n";
						}
					}
				}
			} else {
				foreach $bannedcommandname (@bannedlist) {
					if ($commandname =~ /$bannedcommandname/) {
						print "E: " . $usernameorgroupname . ":" . $commandname . " matches " . $bannedcommandname . "\n";
					}
				}
			}
		}
	}
}
