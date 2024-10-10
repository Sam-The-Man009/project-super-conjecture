{ config, pkgs, ... }:
{
  top_level_encrypt_file = sensitiveValue: (pkgs.runCommand "encrypt" {} ''
    echo "${sensitiveValue}" | gpg --symmetric --passphrase-file ./passphrase.txt > encrypted_file.gpg
    cat encrypted_file.gpg
  '');

  top_level_decrypt_file = encryptedFilePath: (pkgs.runCommand "decrypt" {} ''
    gpg --decrypt --passphrase-file ./passphrase.txt ${encryptedFilePath}
  '');

  # Encrypt sensitiveValue and return the encrypted content as a string
  top_level_encrypt = sensitiveValue: (pkgs.runCommand "encrypt" {} ''
    echo "${sensitiveValue}" | openssl enc -aes-256-cbc -a -salt \
      -pass file:./passphrase.txt > $out
  '');

  # Decrypt the encrypted content passed as a string and return the decrypted content as a string
  top_level_decrypt = encryptedValue: (pkgs.runCommand "decrypt" {} ''
    echo "${encryptedValue}" | openssl enc -aes-256-cbc -a -d \
      -pass file:./passphrase.txt > $out
  '');

}