ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.hfc-key-store
tar -cv * | docker exec -i composer tar x -C /home/composer/.hfc-key-store

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start"

# removing instalation image
rm "${DIR}"/install-hlfv1.sh

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� 8�GY �=M��Hv��dw���A'@�9����������IQ����4��*I�(RMR�Ԇ�9$��K~A.An{\9�Kr�=�C.9� �")�>[�a�=c=ÖT����{�^�WU,��͠bt{��=M5M���C����� � ��O:�Rӟ�C?��4C��7&����L,� Po���зl���m��Z����
hZ�����c���9Ph� ��0��w�K�eU��.w�ޤ֭T�r��F=hj�ބ&9��R.j�0m��� x�����[��jz��I(H�BE,�	�|2���� ��| P���ق��P��CM��j0�-�!�LU	|3�B�G��t�`��|�ÒXٻϓ��j����K�������F�~�z��G��V���"[FN$N�Z%�P����عڅF�F-��Pk�uh�Q��_��͋|�]��0/M��쑤�K�nO�!��^�b����o��^-�d�)���h�c�k�2	�S0��T).b(2V�Ֆm���<�e$�ͥrg�o:��[H˄�}h��ܔ�pOT�@��s�8&=���������U�of�ǄuD[���M��ջ�k�B��"&�%�1�/='��-��m�0;���=��H�І�.kc�2���|\�};����`�����L�ux����U�?����b����,� �o��%����K�oC٬��iZCV�N4\��+��Pt럎�a�������&��dM�ɚl��!�J4���%۠�j��:0a�@T���uUo^�1i���ޓ��k�(������!z�?%�x	�^�7��>���Kye���"z�o�]� �+�[@�K�}M�^ޣ����L4TD��%.OSgVR/���Y��A����RLNhLK͍�- [������<Wf�K�}ll�_��n=�^۫�V1�SL{$�}p������l��h���R��^i�g�F��k#W(S2�љ%賘�5�]\�=�f�uX?��]uW꫶��^7�ב�B��p�b%�(jP� ���R�T�7r߂ �}����|\aÀ/u2���X�)�w4ҁ�c�����՛�sĄ�Ua��\�I3O�kR���P�<~�8Gy����b�5����CKV����-���%�?D�9�u��a��O����a��0T�����v��L����7�|���ݏ�j�4	�/�U
eA|I!��W_��SG��3���Hq�F~P����3�[�7��J ���	����W��������#�������i��`���ij>��E���o޾����-:!�.Pu�M�`τu����P����׹;,�ń�ǫx���]<�����m����v���a��_��-�Xc���c��?���7�I�f��+og�;���wy��m�c���� e�5o��o���5�b戸m$PMg*g��)V��G�	�ͨ����N��|����ǘ%w�,x�Nr|9#���J��6|s�e�ox�  �}݂�7@��~�N`!�!>�f����Ypu��G����lb�T.�[�r��Y5#����j�gЖ�N�������ӅG�i�O��3�=!�?��Tp�ճG�<�����K�h)����G&�^��v������=�7l �߭A3 ���y�nI��2Y���A��:�}�i����E�g[����uw7?�������M�z���N�`]����;�v���m��	����)�N��(;��1l�������_"�����eh����*��Qݮ����g� \�M��n	��+����q�,MrO�u�f��	(������L^[�ϼ���Er�㞰�1E׵��l
���X$2�����v�g#�N��Nf_��G m��v��6\~�g�ީ�1>�[O���j�j��0=�F�t�
Q���u��m�n��q��Ҫז4�J�׵��l
�[�����o�6����M�xm
�X#ˆ]�}�u��~���G\󅙜:�����䥈�f��9��y��a��m�ٖ��"ϼ�G~=EAi��V�:3������g�މ�7��R-�P4(�?�hf7����?�������gb�v�o#�N����rG~۬�u׷l��`?�#�����6�k!�i�O|pZP��Ʉ�Xs"�o�'���ʕ�?�dS�V˿��?�o�!,���Zĝ�n�{��ޣǕp�R
e�(��\A�rR��I�_���@E�[�E���'���ӡi��};�u���_I��*��c�w ��rT���p��N���P�������!��C�W1��:%���T?L�v)�PE%lK�
-����'rs��_:�>�����~�I+8Yy���9�G���l�_}B�&�>����|��������g��
[o�YV�Jم(.�a�^g��+L4܈�:�4d��6���8+Q6��w �;
4�?�{��������?����?�"��<�����{�󫏉����$�S�yJ����4U�q�����ψ�"�� ����A�?�@��`��<�~w�wv��+�s�,��?��ˏf�~��L?3_?q������|��1���Ǩ�G���pk�w~U~6)�ue���L��_�=\�� 1[��������_��W�������'�_�2�����,���v߄S_o����b����������_6�m����'�j�L��ꞧ�VH�c �:ǁ������M:�咆�|������b��e7M��>��>��Vn�����zD%!l�x�f1��o�Mr>P�.B=��:�������.7�l���r���2Pf�0�6�ц��]�5hYfja�w�����nT�D�Pf������{�Ξ��k�K�����)Y�H��lcLG��?ʺz�:Pk��HE&���4�/�� �Y�/m�q�p]�ʾr��	��F\J̋e.�b�TN<s�uX�7W�e*U1�%e�R٧B�����Hb5]H��!�5��-1�I�c;R�jBZ��'��i*�q%�~���Y�ҌƗ����	%�gu���ѳɦѓ�i�
�T�V�掣Ee�t3����9K���.���^�c�͠�Z�Or��m`|uڲ�ϖ��ѭmϽ�lŭ_+����7%�\E��>a��{ʖ��r�5f�b�o������t&��B&_����p�$ɖa��@6I���!PȚ���L���Np��He�)�͜q�4����%��m"�ZBvq	b	�5V!0�䒦cv�u~���^7i�f8x�˂��~�՚�˘�`��籐���AZD��R7|uFr�����BjB��B�v�9�RI�9b�\Pu� d����'���X=*�������p�:)ԶR媢�o��r<W�����
B:��D�_c)�7s��x��s�m��E:��8��%A��\��7d�4�R�JOk�-	��
�r��ٛ������F�]�[޹[5�����{P�[g(�rY���ꍄ�����b�'�����a��K&���rn��g�۞X�n#��*���n,� ������\����#,���q#pG�/��%4n��0��l��	x��_�6o��p�
o��	�!򻜡7s��yG4��]]�}Rt$63(4(�Ƚ#~f`��0�����@���?����SnalB��������o���2������M�f����w����.������o�����C��6���M��������[l��_q�����˂�ߞ��1�b*��X�f����n)!e2B�-\=���53��a)��/���){�m�X�u�e�f��i��R�k�T�B(�$K���8<��"����K����Ӂ�e{'U�H�Kn?��L��OG��ۖ���څx*�׸%�j��Ta5�J�Jj���A�z��=b��I��/8Jjg�R�嫧2*yeܤLJZCB��^���!ϝT9��*�%G�+#:���Ѱw��պZK*�8IέK�]=9�4����U��{
�H帓�'�)��{��d�s������R�fז�GtN�D�8�\�)�+�d��	��$JMNL��Z����ku-�p��J:{4��&0���X ҇A4��~p̫�B�X4zpq��V��>-T.��F�|'�D�*�8'�D���"���$�!�6��/a	�_�J��)A�R\� �4�K��։�ȓNI�8��:'	��慒�1���2���u~N�JT+���Z�b�>�ˆYP���r�R0��#4�G&�3�h&�甹L�&�g���쟔R�^W�c�j,�MiI:V�4�U�U�k=�2	�J�K�E^�m���.v�����@������t���b�pG��O,Z����w�!����_�����&`3�>��M��#l��;����������`�����/��?˄�t��o������at�������U"��5��U�w���:'�$U�35GI�9B�:^Nߒ��Ci(^pe/�nV�N�UKi]����#q�ls^�RM�:�OJ�x�vq�ć�*w�!U1�;:���ǭV혷N+l��PS8��C,Ar�-%/U'�Ȍ�jƑ��.k�eΤ��;^Ǹ�2��1A,G�Oq&Ώ�S)��5E����1�Q�ϩl8B�D�TSɴ�=����b��H��N����s�H�REj$v��V���FL�Aw�CҎUwS�������V#+U�lO.���*�K\���^��u����)�~�r �m��7��;G�ͦ�7�$_R����T�x��*�����:l�T^Ԝ��ѹy��Ή�g�����7��Ͳ��3R;/g��ܞ[}j�3\�Or�ș�܉p�Ԉs��?/�i���lU%/^���\8cUˉ�#.
�A�D3{~�59�EX�:'N�u�HQ�4o��/�X
�C�������m6�)�6������?���>���,�j��7�����m�ڮ �O��?�l�{��F`M���p�_�z���*�5r}�B,K\�KY'��5��eߓl[j�̺��ۢ�f���g�L��V�-<ׯ�9�͠��� ��
� :�
�����^�=\�c�����_�=��À�r��;W��Z��Rj���G�����y�߷�]��{��6(�p����7�����ez����Z��L�C���=���5�=�f��F�����t˪�;�n9����+E�G���G
�UB&��ҷ�(�� �k�;k]5�c�a��!{���)�fh���������^��QD����+���lp�,�>���ldl�h'�G���gu�she�1�xx`�v���+�*j�xЧ�#܍9�j?���h��&y%��߿���H7�?�u�����	�����)�P�A��=�����@�����k�������B����������o�wt-����Dˡ���D"�39��S����$������`��G�"�z�8q�U]��yM�2pV��M��0������i�|�7�}��'Վ�-�M�������=�������u� �D�08��y%�q��cu��Xu��#�i�����J�����K�[��X�d�K;=�MD�2��/.��}4�P�̓�?P�5������Z�~��s�����t���a��	���$���C��7AS��7Y�m���?���O<����FhY�W���]�m������z�����F��gI*�<��OQ�2)Mpl�Ŭ@f�y�	����B��l�	B��l�FD����^�zo���K���M�M�of�<�(�ҕ�k�O�B��yU���A�,z'=�[�n��H��3Gu_^��Lw{މ��mr�U��B	!s�o����}�ӼY���R�1�[�Z�j� ��V��"mR��n�N5|Os#����e}`/:E�n�X��?�X��T�x����O�k�����-���2]X����G'����?ڢ;���mД��h�;E��k���w���w���������[��Ǯ�:��������������g������?q��M�O��8�������J���R����(eU��o��������[����%:/���Wɋ��xz#�ǋ`�D�owq<���X��c� 1�ZLsYP7)�[��g���ڇ򸰌�D���=�}G3��վK���}��1������!˟�}���0���@%B�tT�/g^W����>:��Aߟ�չrhB���J�ս~�V���+��k��?kJÜ���D�C�Q��uA.
~r�RTJ1�0CA]��m�0G�{���^���E���k=����gS�׻�Q}Ɉ���:ۉ���Z�����[��Ǯ�:��4��o���?�������IA�S#@�'�B�'����D���?���������.M|�?��q�tA������D�i�S�Q3�@fCe��l�$YN�\NDS/?2��8؈��,"�w�]��g�	��o�_y��[�����WH��ac	��ͥ��������֋������M���$b��ba��ڽQ�|ݛW74F��K�X��R0�a@��]��P�������u:�a"���o�R,��*���o��?��������Fhd������������	���?����?����P����>��ݥ���g��
������?�GS���L�J��e�m@�A�[����5Z����e@�A������=����\.�y�1��9H#&%9�g�$�	"�i�8�%x�Nc^ i����9�������l�����F���?k4սr��(,}+a�M ��X�u9ǹ���b=���/�?�'J�
��ܚ���ަ\��ִ�bh�m�ei�WR�n!��E--#NYo�RM��avI�ta�8e\���9�9����.��p�C{�����-Ӆ��_{tB��'��?����!�6hJ�t��a��5���'���'�� �_����2��?v��	�������? 6ޙ.��g�?����?|��>.2i>Sz�1�<�������=��k�&�����a��牴^֞�Ч��~J�.}z��+ZRG���V�z��1�599m?���}�	W�T��h^�h9��,���2�8mB���;�i�⮸�τ[��\�����c����\|������  ���߫����0�#��y�M"���&����g��?�E�����2��?v��	���Z�#���%����������?�����P��g�������9��������Ѳ�C�Gˀ���������]�'ɔ�$��8&�(���b&�	�M�&q*��XH<#ٜ�	�ʓ<�������9�������2����=?sĈ���O��aW�ϼ��e�a�Hǟ���o_�?�)MhG�T��D��,�����˭<�]��g���Ҡ�Ge�Z�:��r9T�$K��6��m�b��H�o��4�Q�����҅��?ڣ���?Z��?�����C�GktG�a�`��c�?���������@��B��-��c�����h�����`�������s�������^>�?ԯ��y&;�x[mF��L��_����^���7c��q~�f�1Ώg���lP����F9�%�M�y�����k�׌��Iw�}�Q���2j���)u%����o�[�Y/+��ӯ��pB�.0k�-�ͤJ��Ű�z��7˲8�*Q�+��3H��G�>QǪ{I�dV�R�C�ˮ���?vX^s"�R��Ď+q��ӵ��u`u�BW5�����	z��D}��N��1ǲ�=���c�5��wI�6��ƛM���j�x��Z�{�s=��_<v6]3M�s<�QE�;x��E՟~M��' �z��˟R��Y�v��-���?��Df��Y�1�>��˳M�/L������M%�ˮ�lը�Ш������sh��6]\�p���g�r^�k!���K#�q0�2g޿h�i���]�����Β���[�2��w��_~[�f:Q�A�Gk�\�A�Gˀ����_'��?Z�#���%����������?��?n��=���K��O��NC��]��	�{]����Fx����c�;�����g�h��F������X��o�f���u������$����w#4��4H��� M����A�K#���*��u�����"���^jr+�˷���z���������[D|�O$]�� W^������5u�1��}�˦�G܅ �/��q��T�Ⱥ��@�/SWܨ�o�kZ��?kExro��nI-=R�֪R�懂[J�S�����_ӧ�~�O�3�>��*L��qꏢzc:2�������(xƼ�H)��y�,�&뫵sSggSqhk
�x{�g�$XƢf��e[��t��#X8����p̯������_���G��ƿ[t��?�����_#��������R�Ps�S_��?�DV��v���e���C]����m��Co���w��8f�B�[��� �\<�{���q''+�?�lB�f�ќ�'����<ܫ�9�횳�8c���tǿ)�o�������:�;c�^��k��~����6/	�/mx���8������ɢ��"����m�Xx�c��x�i�n�a���~up�0:n��bTd%*VE�/S�Wҁ�\�R䣵�V4�5H]�{����M���$���K����C����p̯������_���G���k�������?������h��_�����*M|�?��)�tA�I������)����ߓp �U@�A�[����/�h���������>*����m�?E<���4BW��'��SJ�p�f8"�S�r
'#�<�3��b�◗H6"X2�H6��<��?�����{���X��C�g#|���Y#9ʿt%���S��P��u�D��Go�4�r�:�3^^�'~\Ilh7�����c��1H=�-,4����2gs��VO���P�M�{�6��p�>�9������>��9��t����bm���P�p>:'4�Ũ�?�3��T�x����O�k�����-���2]X����G'��������C0T4��?��D1��� � �	� �	�?��k���`������N������6Bg���`�ߙn����O����?�L�o�^Na�G9��ԋ	-H�C5V~���/?��"�u��OTo�����#��w�x
v�"a5̩ɐ^�+7���f��vȝ��װ邺h�![�&E̦��AN��i﫞tҳQ�\�%S���˰��G<�o�xv2r���?��|{����h'*2���=��Qm�IG/���3�Յa�eO�9n���<Ck�*|0��TN�?o0�U��_�S	�2W�9�	��3}&�M�OW�a��a4&�j�Ws��#�i=*�8�h��Ex���ˈ&>;fֽcr��G�y�]d������7щ��?Z�����Z��Ǯ�:��4��o���?�������D���� � �	� ����'�}]���o��_���}wi����O���������hD�i�N�3!΅�Ky�c�4g������H��ٻ�.[c����և�fPu�FH	1��$z�����yq��y�tW|� +��6��{�s�>�2t�3|D14K\�DL�q��l��?(�������ׂ?y�{�<�r���A`:�6#��:�h�-\��e[x��L;%/��-VS�*Vzm��)�Fn�C��\�b��M��0X����/x�*�̈́���R�Wp�E�Q��?͊�S���n���
�����C@���r�CuY�u����OPp����C���P�����>��?���]����N������ ���͡.����B� ��o��a�Cch��a�C� ��o��a�Cs@���@�8��$M2�R!䓄	y&`<�*�������#��0��N���y��aD����?��a!�����!:ۅ���s$�]�{2�I7P�٤�+�i��Q�p|���O�ɑ�g�c�p!�v�[=�p%{�V��q|uhm���rlO}��M�Fh��n(��M�a��Z���"v����[�����C��?�h(������O?������?�6����������'���'�����?���0��n���C�Cc@��a�c#@��?������� �������?����?���0��n������ƀ���o(���7��C����������&�_	��@��?��C��!��14�����0��������h���l(0!Ŧ��,OƂ0Tʤ8)����G1!ND&�m�P@���P���h2�od}&��`�y�mE����)O�3)<�nz�Gm���a���a���3zg��HS(��6v��;q�
�kN��ք��í8Y�`o8���Ego��0�]�VQ_��Ù;J�'a�o
�?�4�����h(�����������& �?���a��`�� ��_��?��ϭ�����h�������@���{�����ׁ_�\������a���v��^2lmL�?~+�ÍH�lL�E�G\z�\6��o�i�WO-�ښ���n{2����a3�������c4	��>�gR�k�uRu��ֲ=w<�S�2�d�?��{���\4���)Y����h��>x�R<��T�sz)G�BY�3�l���������"�t�I�'saF�1��fn�F�_�7l����5��M@B�A�GchX�A�G� ����������P����o����?��?o��_��f'���������(��u�#^�>~��4����_�U�m�����$��u �u���B?�p�] ��7��0��j���h(�"������_���'����Z��oW�e1�����|v��C�2�������Y���Et��e�a)۪��y�J���J���|���#_���|���{Si�י��םOo.�b��s6�+R`9'�<�6�v�R_Iܑ�Fz��zy~ؔG#5�\ٻ�0�����'#f�_yk�(f�>���D2�s){P��lq|�:`�z��<����k�.㊹(�Y��;�UVa��7�����N�e�r��#�%S]+����&���[&S���y���s���J�#�P-��9&nj!k-�@J�b�fY��擙��ݽ�eꗧ�X\���h㚾���^�Y���>����ij۠��z+�-y�Y�G@A�]�޽��W�8��� ����
�O���kA���5 ���{�����Z�+�o������{���fougA=�.����y��χ6x����zM��u�K�qR��cLʢ�٦��m�ɐ��K��B�������ȓ��O)k����<�	�Y�|Q�}jǃ�׶�"������s��o�3�̊�Z�3�YT��8|���<�u��_i֗�aKI�U�諷ߋ����|I�&]�R+�����6څI�o�����R4�h��Y���E/��i{dZ섧�3��#���c0�R���c#���ow�tF��\>#=���.�T@���ǎ�G�i�ن3]��m(,[JK�2ڽ�i���zGV��v�{3��fG^�Vv��������p���q��%/t��s�?���͡N����uX�Ph(��y��'��ׁ_�)��{�����[ٝ�W/�m������^��˨�r�J����yWƸ��\��ܶg��].^���q����y��<�<��z�}�>�&O�N֙�:����v9s�YDm�r/ᦕLM9+ZwUW:ʗ0 ֧XqU~:Z�W��s<�׬6�̶�[���ͥ�6�k�I���'�EK|�t��$�jG���[N��P�Q��`-Wt�ˑ!�_�!���K?���DC�Ƚ�vz�l�ґ˧�g��`#LJ�o�G��Ӫ�2�"!.T;_���u��I��~0�1YY3���!����)J�����~�=��������kA���?����� ���@��?�����Y��P�C(�?�}P��@�Ձ_����V�[�����_ɘ�ү���M�K�V����� ��RS��S��������8����&�qKWR1��-��ɞ9#��s�kw��!Ɉ�M?�/V���Gv�M5)x֎Nn��=a�jt��ťx�}u@����;�р��F��V��LN�1���<��Y��b�KВW�Lq����u��h��s���E>v�A��;���e6J�Y/�g|Ku�vf�}����U�a�Ѷ=d��W������<������Ps����O����{�����:�������9Z�MV���-�x��Z�5����%���!��?����=��/�&��j��:]y��8i[�cgU��:G=8�6��ꪜΩ�@<�tJ��S��{cA#K1���Y��t`8�`ػ:�?��Dp��]F�a���Ξ.C>NO�E�=l��;��.���Ϟ�H�[�{���!�c
s7���n%�`�h_��-�T��J���ܓS�P��	�Ec��$,�J
�7���f'�Oo�-	����Q�E�Ɓ������������d��Mu�~�Dm9
]{�k�(a&q}(8�ex��p���}*��	�mQ�DM���uQeF�>.���Q;�T]s��K~_ݯc]��MسQ�Z�%�T��k:1�wu�����w�O<j�v�L���TT���S��V���t�kn�j��_�̗���cm�(>���<E��2��Mݓ7޲�X"�+,�_.��>��P�k��� ��8P�P�k���������?��w= @�5��>�_��DQ����~_�}���H�?���s��u�6���w�a���������?�?�'���@��_$���'p4������z4������	�iQJ$)$��lJ)�&!��!qDz�1�K
B��	3|��G}���@��)����j�������X�����i]1S��u�$��[oв2\ڻ������O�#���b�3�޲��NE��JΓ���o���v�e���t��1�g�f&���b��[Z�z�I7\��wfz4���o��Q�ke&�I�o�;�����������'��1�p��ă�/��:�����
�?�����w����WP�X���������?���j����o����	�G����kA���7���[�!�������S��u ��V( �4�?{�����Z�K���y���y�(-�8#>K�x�Z4i������?���J���������B�����|e�z��b�?(��q[��R��D1N�i�#�?e� ���f�Y��i6�6���Hz���t�#s�<m���j�q[��&��߶ԡ:�C����\�X)ٗ���6�$�.Rz٭*��<}߲�g�~��֤#U�7���L��j��!�d��m�/+���x�يL�욚�n�\p�Ғ��L�r�cgv���l�sywk�'q!�s*~�����wZ"6X��|�t��2�F�&��v��M��� ��������q�����	������?� 	������w�������a����������z�����_P��w7����P��?�{�Q���~�Oq��������A�^����#��O����q�A�0�s\��'�R\)��,�<I�|�0�@�q���'D	�{| �������?�_����p0)���0<�v�a�?�J!���&�;߫�m��,�/�?�/�M���|������xt�C�G-�h�?���2�x��_�����G��<���.�	�?jB=���'" ��o��I�A�/��Z��C�; ��o��)������8�')��|L�Ϧ$E�lS���yB`X"��$�8.M<�H�Jt��qBpB@E��W@���Ӑ�W�d�g�hsN8��d5��6��|��-DG�_�9�V(��)����S$���y�Zƺqp�Z�[��E-��q��$�.z4�z޽���%&���G��Z��,f��ɜi�9���93���V�p���]���	M����P8���5$��z��	�� ���!�.���o��j����p��4��������	M�?�~G��?��C����_����?l~kH���߮���������������
H�?���w��V������n�����?���M�?��f�����c��?�����y�����C����?Y�N�E��p��~!��$C�{��Hv����no��f(��4"T��̲=�v����d U��|�*_��Q�.v�usU�:�<���e B�#��"R��E �	BH< �Hy
�|k����==�3����m��s������믃�����[��$ȷ����{���������������{���?���?lw~�.}+�[�q�aC�p녽�w������|����mA5T郯�x�����fP
�"��*BDB�	Q��7�A,�#b8��f3���P	o�{�;e�O����@�����w��������Ճ/~�����?��?��o߁^�5ô]��;�On��}��Mu����o��yz�&(��?{�wނ^����[�Oބ��͓��|r��	��Ņ���rS�$�xo�[��H=iL�Dm��t26nL��p��0S��a�-�^�����C�Sƪ^^g�7\�u�!Ĕ ��00I3���0^^��$�-a	G�6���<]e�Ҭ�#&_�}(M7��j�#���n0�8��fJ��ÅױqI���O�h���n�S��jC��&��^�sR���������	c�IcZwj�`;K����ꝑߍV�Xsi�N�Q��Z��<i�c8'�ј�W��Q"[�������U:���L�;�`������0�ٕp����Jc0)D%e�S<�5��Z�M�ЙZ����w|k>MPd�Pi���:քz�n�W(�Z�!)`Y^�O2$���R����鸂�T���5�6�����t���B�i&�i��܀��. H���.�*��I��I���H=�Y���a8L�Ɋ&v�<M,y�u�_��|�Ny�o���@���%�'�h�F�2�=��6�lF�D\��Z|#H(V�@��
ZӍǚ��3�#'��#�~�D˕D��F���8��L�9:�w1���Z�w*r�.N�M3D�c�8Q]�i[��ӉDi�/�(�(�K����䄨��~��.�/u��u�S�sot�ni]���~rߟG�L��P��p����6kj��K&"E<�Q�	{�Y\�bE��ɡ�@TX=Ov�f>W��U-ŕ�C�(X6.Ҧ�>��O�Y6Yr2�_��D���{��5��8�廢�-U&-����Z�$)�B�㓦�#����Z�h�Y��˶�d��l�a�Hof��,DIc*NM�&�ZT�,�0x�Bp�V<�,kħh�,);DPxmd�I"��4cT3Vv�Q��L�|���L�@��2�(�r����#2��v��T#hY/5*êR��t�=+N�.b�'��u���[��.�+%<5��"�k��Y��'k+& :�� ��s�u�Σ��]Ň팠�M���a��M,�Fg�5�a7>l0��Q�C����cN��\3�%󽦤%��ƥ��A�br� S��ZJUBq�&�F�F�C�o�"8^�Ԍ��t�e+�(p�x\	�b����p�sh� �c�dn�� _uz=T�p�ةa��d��E�.�}��B�+���\���^��_�H��t/kfm�̕�CRk��$�I-�F����{M+���0��R�
����I��$6�$'����3�Ac��"���B��ĥ~����^�Zc_ z�j�.�����������2����g�^�_]���(4�߁~a��.�ڲ��C8�	+��7�`q��|cZ�y��������Ly�d��.�G�'��+��dMy/��ߖ��lUm��3��هXnByOo���!zޔwu���HJ�u�F ���\y̠N��hT��^����	��y�C��"�
X�W��:,�K���L�\*�[}(��,_ӕj	���P��$_)�澬�5�(U)���L���Dm}�$F��ƚg��P�i�^U3{f�c�P}Rǝ��W�*��P��N�k��rJp�B��n���mժ��Wi)��ES���d0X69ܯe�~K���0��Vj��\d�D��eBj�z&{	;� ��s
��ǂXn"�[B�U�X���k
�/Q*7�`�R09H��
U�{Dd�b���\u�''�8��D�W�MT��e��3
Z(�4!���j_���� j��Ď��Xy��P�$S��hf5�h�%�r%��V]
�N���z��Bf��ZV0��h�4A�t<MGi���kr^�fY�M�)�).C�J/"��|Mm���zj�]b�ǀX����Co�ۂa�Zܖ�λ����~~}�Exgі��K���}��S �g��O߇��O�����ܙ�����}�֝S�߹t��z��ާ���\{ɷ/���>����Dg�����n��� �hrE[uU �px���_����a�v ����}���c�|k���U*>�&F�I3�d'%���*��5�a��YqTQ�ԡ�D�6�����&���zЈ� GşFێ<b���dN|-t���ݤ�k-�c������Z+��k�FH��a����+mS�&��b �� v9�V���m��
B��c�p�.Z�B8ܩSY����f��x�[���c����9>�~�����/�[k�Ϙ�j�=�z7�~��%x���z�tF�>Ҕ<�2�q�xo������eo�����y%liݸ�Ң�K���-��츶*N#���ޗ�]�A�p�?�d��2��cj���J
���ԉ�	�������|��r�ק4���f߅~��K[��w2`oû;/z��y�*�b|�4���p��H���[�]�| }���í�*M����r�nC� �U�Eh-�u�l��'~� ���ڔ�
�
�k�E�oOGo� }~I�n�燐$[vف߃��w�"�+�!G�@8��c��_���ٿOkz��Y�b���?�` |l�?o =�h������?�PzL��0L�#�(�R���%(x��hE<����7c1, c���XP��J�;���g��m�����%����?Q̋����<���.��\:�<)gZ<g�Or�B�g9��(g�޽ݕC|�[��G�g'=������������VϺ���|��<�n��&�*�����8 ��� @.�ۯ�<)�R���B�����=�u$!P	���ݏ��' �
!4�TK4f�X��H)-Z�_5�F���C�pELK�V�s�Ċ�9����$��<�R7�c���R_�[��>p�?��ǔ�����t�����?����'�c[��F��!��ȷ�Q�]��X���9 �65��}M��E�ԩ��R� �..'�p�s}G|��U����o�������j|�{�#X���{������z]���wl\7h�ظnHñqݰ��s��� zqͨ�c㺑���uC����׍l86�=xl\7|���4~��x�K���=|��Y�S��t�������P�M �������Hd���#��E�[������M��7�A�"�Hu�@�v\D�mӾ�����"��!@�Cr!Gv�y �$m���m����T[]�CT���{�}D��x����$��}�Pf�􇁯>�!��Cn�F���A��#�����p�wz/4�;���q߂5?X!o+�AW8��2(�Mk�X@�A�gN"��)�� �_���NE�8��wAC���� ���z�з�p�ڻ�TjYP#'�@��8u�˻e����@~m�:)9�8�=��|��j����2�nz��!Ns@z�����C m˶�#�_3EAk��;u����Sүί!
����w}׵��|w����ѯ>�{8��7i�ځ<X~��r��2��=�i�n-��0�T�������!^���
�pm��(ΞA����Ǽ(�i�+Yj��٘=J��S�b�D|)0S�&K-�A�5x�?H[p��,sn�Ŵ�L�Z+1]ԑz \�<C�}Ц���ƛ�7���(P���_`j�����~�|��[3.�����b��������7����* �/���
H�؝��t�C��A��t��X��G�ƽ����_2��f
��׀��?���0�m��F�S��''�J}WMu�R��f�k}�*�>!�К�B<#�y�$Qu�%�ۇX^��	�Bx<�)��(���C�C�y-jy�ڸ�Ŕ��>�������`{���?|V�C���Dz^��]�k�ݩ�N�M�$�d]A5 �.w9��qe���9��u�]�n��ŭU1�!"j�`�"V�́j�Vy�:��c�[[4{����X�f5gS��$+B_s��NBNꝘ; ����
��Ʀ<v����u��x��l���']֛`��x!3p;:qN� �eڮs45[ w<k�Ԥs��W�#�T���ix����}� ah��Y����ǉ��O�	2GS�\�t}h`.n�g":�A��]��J:5��`^���Z����$^`��E�f���G��E�t��6w���P�B:���������o���:�c�J��L����9�B��Q4YN��q��F�Lv1��O��+z��2�ޤ�K�_�:�mB���2���&�l!�����k]Z�?Y����α�������償b�%:m�@D�8�,[H�Wg&`Ô b �w�Y�Z_���9o����|�B��U�?`�� t������@x���Hz��?S�L�j�"}��+��*�����6D�6E�HE	�ɘ*ٵc;IU*�R�
�"u�/�U7�Ҥ-���H��X[�
���ЎL,LHE��ٱ�4Mڨ���oI�}�q����w�EY.5��hp�b��e����CI�W�7wS�1
 ����~��$Pe�YwQ��������3�:�.�ã�������9e�>v���d_�6��L-��?�b&�_4oڴ�l�C�g��U�%�n��3@z�?�󿦚G�����?�3'Φh����*�.�7�"
�C���/0ks]��E0��$���Pl���z�:=��16�]�)�� �E��:�5o�&5�1�<�'20��Bd@��߷�2�8�)�H���43����U���pU�`c��-�?N�%UQ���0ot"u������h�t��B̍ӑ��Y���|�o���7�Q�^ ��~��&�Q�x5^q\A����ju���k�*g���ֽ�s�$�ن6�؂�6x�  �=
oԧU��k BZ�aK&��90�Ǟ�*[�_���+7w�W�[������QT��3ᤰ'W���U#g�_���p�`V��J���N�f��؃��x;�'�\W�⫂��Ҧi���-E��%Sm%�c�Y^?��vkG�#�'*���U������y���Z��jY}F��:�wFXwuq4��8��4]Ǣ&1qO+Pb�e�4	5T2E�Yݢ%�6�y+��lN/�5C�I�"%�L�RN%���Y�
��� k��o�w��6����n��q��|dz?��&�үR�R�p'}i��]X���2	�a(!3%eX�2!�zM
�f�/�[O�1:�r���L�d�J{�1V%)oKRe��c�m��&��r=/X���c[������w�/��Km�����+=����A��t�������!�|lt��H�9a�FNG�P����FRn�E@]�E�ou0�;fpG�g�F�g�F�gT�AE�F�g�F�g�F�g�F�g�F�g��8�90΁q�5΁�U��q���Va�������Ϩ���Ϩ���Ϩ��@ �@ D _+ � 